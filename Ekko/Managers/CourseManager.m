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
#import "DataManager.h"
#import "CoursesXMLParser.h"

#import "Course+Ekko.h"
#import "Permission.h"

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
    self.managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    self.coursesFoundInSync = [NSMutableArray array];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerWillSyncCoursesNotification object:self userInfo:@{@"guid": self.guid}];
    });

    //TODO - increase limit
    [self getCoursesStaringAt:0 limit:5];
}

#pragma mark - CoreData

-(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (results && results.count > 0) {
        return (Course *)[results firstObject];
    }
    return nil;
}

-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    NSArray *courses = [managedObjectContext executeFetchRequest:request error:nil];
    if (courses != nil) {
        return courses;
    }
    return [NSArray array];
}

#pragma mark - NSFetchedResultsController

-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
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
                                               managedObjectContext:[[DataManager sharedManager] mainQueueManagedObjectContext]
                                                 sectionNameKeyPath:nil
                                                          cacheName:nil];
}




#pragma mark - CoursesXMLParserDelegate

-(void)foundCourse:(NSString *)courseId {
    [self.coursesFoundInSync addObject:courseId];
}

-(Course *)fetchCourse:(NSString *)courseId {
    Course *course = [self getCourseById:courseId withManagedObjectContext:self.managedObjectContext];
    if (course == nil) {
        course = (Course *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:self.managedObjectContext];
    }
    return course;
}

-(Permission *)newPermission {
    return (Permission *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityPermission inManagedObjectContext:self.managedObjectContext];
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
                CoursesXMLParser *parser = [[CoursesXMLParser alloc] initWithData:coursesData andDelegate:self];

                if ([parser parse]) {
                    if (parser.hasMore) {
                        NSInteger start = parser.start + parser.limit;
                        [self getCoursesStaringAt:start limit:parser.limit];
                    }
                    else {
                        [self processSyncedCourses];
                    }
                }
            }
        }];
    }];
}

-(void)processSyncedCourses {
    if (self.managedObjectContext) {
        // Find all existing courses this guid had permission for but were not returned in the sync.
        NSFetchRequest *fetchRequest = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
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

        [[DataManager sharedManager] saveManagedObjectContext:self.managedObjectContext];
    }
    self.managedObjectContext = nil;
    self.coursesFoundInSync = nil;
    self.syncInProgress = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerDidSyncCoursesNotification object:self userInfo:@{@"guid": self.guid}];
    });
}
















-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete {
    [[EkkoCloudClient sharedClient] enrollInCourse:courseId completeBlock:^(NSData *courseData, NSError *error) {
        //TODO Fix me
    }];
}

-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete {
/*
    [[EkkoCloudClient sharedClientForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] unenrollFromCourse:courseId callback:^(HubCourse *hubCourse) {
        [self updateCourse:courseId withHubCourse:hubCourse complete:^{
            if (complete) {
                complete();
            }
        }];
    }];
*/
}

-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete {
/*
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        [course.permission setHidden:NO];
        course.permission = course.permission;
        [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        if (complete != nil) {
            complete();
        }
    }];
*/
}

-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete {
/*
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        [course.permission setHidden:YES];
        course.permission = course.permission;
        [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        if (complete != nil) {
            complete();
        }
    }];
*/
}

@end
