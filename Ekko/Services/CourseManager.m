//
//  CourseManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/29/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseManager.h"

#import "HubClient.h"
#import "DataManager.h"
#import "ManifestManager.h"

#import "Course+Hub.h"
#import "Permission.h"

NSString *const EkkoCourseManagerWillSyncCoursesNotification = @"EkkoCourseManagerWillSyncCoursesNotification";
NSString *const EkkoCourseManagerDidSyncCoursesNotification = @"EkkoCourseManagerDidSyncCoursesNotification";

@interface CourseManager () {
    BOOL _coursesSyncInProgress;
    NSMutableDictionary *_pendingHubCourses;
}
@end

@implementation CourseManager

+(CourseManager *)sharedManager {
    __strong static CourseManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[CourseManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        _coursesSyncInProgress = NO;
    }
    return self;
}

-(BOOL)isSyncInProgress {
    return _coursesSyncInProgress;
}

-(void)syncAllCoursesFromHub {
    if (_coursesSyncInProgress) {
        return;
    }
    _coursesSyncInProgress = YES;
    _pendingHubCourses = [NSMutableDictionary dictionary];
    
    NSLog(@"%@", [[HubClient sharedClient] sessionId]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerWillSyncCoursesNotification object:self];
    });
    
    [self getCoursesStaringAt:0 limit:50];
}

-(void)syncCourse:(NSString *)courseId complete:(void (^)())complete {
    //Fetch the course from the Hub
    [[HubClient sharedClient] getCourse:courseId callback:^(HubCourse *hubCourse) {
        [self updateCourse:courseId withHubCourse:hubCourse complete:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

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

-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseTitle" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]];
    
    switch (type) {
        case EkkoMyCoursesFetchType:
            [request setPredicate:[NSPredicate predicateWithFormat:@"permission.guid LIKE[c] %@ AND permission.contentVisible == YES AND permission.hidden == NO", [[HubClient sharedClient] sessionGuid] ?: @"GUEST"]];
            break;
        case EkkoAllCoursesFetchType:
        default:
            [request setPredicate:[NSPredicate predicateWithFormat:@"permission.guid LIKE[c] %@", [[HubClient sharedClient] sessionGuid] ?: @"GUEST"]];
            break;
    }
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[DataManager sharedManager] mainQueueManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete {
    [[HubClient sharedClient] enrollInCourse:courseId callback:^(HubCourse *hubCourse) {
        [self updateCourse:courseId withHubCourse:hubCourse complete:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete {
    [[HubClient sharedClient] unenrollFromCourse:courseId callback:^(HubCourse *hubCourse) {
        [self updateCourse:courseId withHubCourse:hubCourse complete:^{
            if (complete) {
                complete();
            }
        }];
    }];
}

-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete {
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
}

-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete {
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
}

#pragma mark - private

-(void)getCoursesStaringAt:(NSInteger)start limit:(NSInteger)limit {
    [[HubClient sharedClient] getCoursesStartingAt:start withLimit:limit callback:^(NSArray *courses, BOOL hasMore, NSInteger start, NSInteger limit) {
        for (HubCourse *hubCourse in courses) {
            [_pendingHubCourses setObject:hubCourse forKey:hubCourse.courseId];
        }
        
        if (hasMore) {
            [self getCoursesStaringAt:start limit:limit];
        }
        else {
            [self processPendingHubCourses];
        }
    }];
}

-(void)processPendingHubCourses {
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlockAndWait:^{
        NSArray *courses = [self getAllCoursesWithManagedObjectContext:managedObjectContext];
        for (Course *course in courses) {
            HubCourse *hubCourse = [_pendingHubCourses objectForKey:course.courseId];
            if (hubCourse != nil) {
                //Update existing courses
                if (hubCourse.courseVersion > course.courseVersion && course.permission.contentVisible) {
                    [[ManifestManager sharedManager] syncManifest:course.courseId];
                }
                [course syncWithHubCourse:hubCourse];
                [_pendingHubCourses removeObjectForKey:course.courseId];
            }
            else {
                //Course not returned from Hub, delete it from CoreData
                [managedObjectContext deleteObject:course];
            }
        }
        //Add any new courses returned from the Hub
        [_pendingHubCourses enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Course *course = (Course *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:managedObjectContext];
            [course syncWithHubCourse:(HubCourse *)obj];
            if (course.permission.contentVisible) {
                [[ManifestManager sharedManager] syncManifest:course.courseId];
            }
        }];
        
        //Save all context changes
        [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
    }];
    
    _pendingHubCourses = nil;
    _coursesSyncInProgress = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoCourseManagerDidSyncCoursesNotification object:self];
    });
}

-(void)updateCourse:(NSString *)courseId withHubCourse:(HubCourse *)hubCourse complete:(void (^)())complete {
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        BOOL shouldUpdateManifest = NO;
        //Fetch the course from CoreData
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        if (course) {
            //Update the CoreData course if data came back from the Hub, otherwise delete it
            if (hubCourse != nil) {
                shouldUpdateManifest = YES;
                [course syncWithHubCourse:hubCourse];
            }
            else {
                [managedObjectContext deleteObject:course];
            }
        }
        else if (hubCourse) {
            //Create the CoreData course if it didnt exist and we got data from the Hub
            course = (Course *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:managedObjectContext];
            [course syncWithHubCourse:hubCourse];
            shouldUpdateManifest = YES;
        }
        
        //Save any changes made to the CoreData context
        if ([managedObjectContext hasChanges]) {
            [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        }
        
        //Sync the Manifest if necessary
        if (shouldUpdateManifest && course.permission.contentVisible) {
            [[ManifestManager sharedManager] syncManifest:courseId complete:^{
                if (complete) {
                    complete();
                }
            }];
        }
        else if (complete) {
            complete();
        }
    }];
}

@end
