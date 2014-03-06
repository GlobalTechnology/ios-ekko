//
//  CourseManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CourseManager.h"
#import <TheKeyOAuth2Client.h>

#import "EkkoCloudClient.h"
#import "CoreDataManager.h"
#import "ManifestManager.h"

#import "CoursesXMLParser.h"
#import "CourseXMLParser.h"

#import "Course+Ekko.h"
#import "Permission.h"
#import "Banner+Ekko.h"

NSString *const EkkoCourseManagerWillSyncCoursesNotification = @"EkkoCourseManagerWillSyncCoursesNotification";
NSString *const EkkoCourseManagerDidSyncCoursesNotification = @"EkkoCourseManagerDidSyncCoursesNotification";

@interface CourseManager ()
@property (nonatomic, strong, readwrite) NSString *guid;
@property (atomic) BOOL syncInProgress;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *coursesFoundInSync;
@end

@implementation CourseManager

+(CourseManager *)courseManagerForGUID:(NSString *)guid {
    __strong static NSMutableDictionary *_managers = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _managers = [NSMutableDictionary dictionary];
    });

    CourseManager *manager = nil;
    @synchronized(_managers) {
        guid = guid ?: [[TheKeyOAuth2Client sharedOAuth2Client] guid];
        manager = (CourseManager *)[_managers objectForKey:guid];
        if(manager == nil) {
            manager = [[CourseManager alloc] initWithGUID:guid];
            [_managers setObject:manager forKey:guid];
        }
    }
    return manager;
}

-(id)initWithGUID:(NSString *)guid {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.guid = guid;
    return self;
}

-(BOOL)isSyncInProgress {
    return self.syncInProgress;
}

+(void)syncCoursesForGUID:(NSString *)guid {
    [[CourseManager courseManagerForGUID:guid] syncCourses];
}

-(void)syncCourses {
    if (self.syncInProgress) {
        return;
    }
    self.syncInProgress = YES;
    self.managedObjectContext = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    self.coursesFoundInSync = [NSMutableArray array];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerWillSyncCoursesNotification object:self userInfo:@{@"guid": self.guid}];
    });

    //TODO - increase limit
    [self getCoursesStaringAt:0 limit:50];
}

-(void)syncCourse:(NSString *)courseId completeBlock:(void (^)())complete {
    [[EkkoCloudClient sharedClientForGUID:self.guid] getCourse:courseId completeBlock:^(NSData *courseData, NSError *error) {
        [self updateCourse:courseId withCourseData:courseData completeBlock:complete];
    }];
}

#pragma mark - Core Data
+(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (results && results.count > 0) {
        return (Course *)[results firstObject];
    }
    return nil;
}

-(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [CourseManager getCourseById:courseId withManagedObjectContext:managedObjectContext];
}

+(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    NSArray *courses = [managedObjectContext executeFetchRequest:request error:nil];
    if (courses != nil) {
        return courses;
    }
    return [NSArray array];
}

-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [CourseManager getAllCoursesWithManagedObjectContext:managedObjectContext];
}

#pragma mark - Enrollment
-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete {
    [[EkkoCloudClient sharedClientForGUID:self.guid] enrollInCourse:courseId completeBlock:^(NSData *courseData, NSError *error) {
        [self updateCourse:courseId withCourseData:courseData completeBlock:complete];
    }];
}

-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete {
    [[EkkoCloudClient sharedClientForGUID:self.guid] unenrollFromCourse:courseId completeBlock:^(NSData *courseData, NSError *error) {
        [self updateCourse:courseId withCourseData:courseData completeBlock:complete];
    }];
}

#pragma mark - Visibility
-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete {
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        Permission *permission = [course permissionForGUID:self.guid];
        if (permission) {
            [permission setHidden:NO];
        }
        [[CoreDataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        complete();
    }];
}

-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete {
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        Permission *permission = [course permissionForGUID:self.guid];
        if (permission) {
            [permission setHidden:YES];
        }
        [[CoreDataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        complete();
    }];
}

#pragma mark - NSFetchedResultsController
-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type {
    NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseTitle" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]];

    switch (type) {
        case EkkoMyCoursesFetchType:
            [request setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(permissions, $p, $p.guid LIKE[c] %@ AND $p.contentVisible == YES AND $p.hidden == NO).@count != 0)", self.guid]];
            break;
        case EkkoAllCoursesFetchType:
        default:
            [request setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(permissions, $p, $p.guid LIKE[c] %@).@count != 0)", self.guid]];
            break;
    }
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:[[CoreDataManager sharedManager] mainQueueManagedObjectContext]
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}

#pragma mark - CoursesXMLParserDelegate
-(void)foundCourse:(NSString *)courseId isNewVersion:(BOOL)newVersion {
    [self.coursesFoundInSync addObject:courseId];
    if (newVersion) {
        [[ManifestManager sharedManager] syncManifest:courseId completeBlock:^(Manifest *manifest) {}];
    }
}

#pragma mark - Private Methods
/*
 Sync Process
 1. Get and insert/update all courses from Ekko Cloud for current GUID
 2. Fetch all courses from Core Data not returned by Ekko Cloud where the current GUID has permission and remove the permission
*/
-(void)getCoursesStaringAt:(NSInteger)start limit:(NSInteger)limit {
    [[EkkoCloudClient sharedClientForGUID:self.guid] getCoursesStartingAt:start withLimit:limit completeBlock:^(NSData *coursesData, NSError *error) {
        [self.managedObjectContext performBlock:^{
            if (coursesData) {
                // Init parser and parse - this blocks
                CoursesXMLParser *parser = [[CoursesXMLParser alloc] initWithData:coursesData managedObjectContext:self.managedObjectContext delegate:self];

                if ([parser parse]) {
                    if (parser.hasMore) {
                        NSInteger start = parser.start + parser.limit;
                        [self getCoursesStaringAt:start limit:parser.limit];
                    }
                    else {
                        [self processSyncedCourses:YES];
                    }
                }
            }
            else if (error) {
                [self processSyncedCourses:NO];
            }
        }];
    }];
}

-(void)processSyncedCourses:(BOOL)removeExistingPermissions {
    if (self.managedObjectContext) {
        if (removeExistingPermissions) {
            // Find all existing courses this guid had permission for but were not returned in the sync.
            NSFetchRequest *fetchRequest = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(permissions, $p, $p.guid LIKE[c] %@).@count != 0) AND NOT (courseId IN %@)", self.guid, self.coursesFoundInSync]];
            NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            if (results && [results count] > 0) {
                //Remove permission for existing courses
                for (Course *course in results) {
                    Permission *permission = [course permissionForGUID:self.guid];
                    if (permission) {
                        [self.managedObjectContext deleteObject:permission];
                    }
                }
            }
        }
        [[CoreDataManager sharedManager] saveManagedObjectContext:self.managedObjectContext];
    }
    self.managedObjectContext = nil;
    self.coursesFoundInSync = nil;
    self.syncInProgress = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerDidSyncCoursesNotification object:self userInfo:@{@"guid": self.guid}];
    });
}

-(void)updateCourse:(NSString *)courseId withCourseData:(NSData *)courseData completeBlock:(void (^)())complete {
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    if (courseData && [courseData length] > 0) {
        [managedObjectContext performBlock:^{
            CourseXMLParser *parser = [[CourseXMLParser alloc] initWithData:courseData managedObjectContext:managedObjectContext];
            if ([parser parse]) {
                if ([parser isNewVersion]) {
                    [[ManifestManager sharedManager] syncManifest:courseId completeBlock:^(Manifest *manifest) {}];
                }
                [[CoreDataManager sharedManager] saveManagedObjectContext:managedObjectContext];
            }
            complete();
        }];
    }
    else {
        [managedObjectContext performBlock:^{
            Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
            if (course) {
                Permission *permission = [course permissionForGUID:self.guid];
                if (permission) {
                    [managedObjectContext deleteObject:permission];
                }
            }
            [[CoreDataManager sharedManager] saveManagedObjectContext:managedObjectContext];
            complete();
        }];
    }
}

@end
