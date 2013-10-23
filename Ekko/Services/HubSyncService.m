//
//  HubSyncService.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubSyncService.h"
#import "DataManager.h"
#import "HubClient.h"

#import "Course+Hub.h"
#import "Manifest+Hub.h"

NSString *const EkkoHubSyncServiceCoursesSyncBegin = @"org.ekkoproject.ios.player.HubSyncServiceCoursesSyncBegin";
NSString *const EkkoHubSyncServiceCoursesSyncEnd = @"org.ekkoproject.ios.player.HubSyncServiceCoursesSyncEnd";

@interface HubSyncService () {
    BOOL _coursesSyncInProgress;
    NSMutableDictionary *_courses;
}

@end

@implementation HubSyncService

+(HubSyncService *)sharedService {
    __strong static HubSyncService *_service = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _service = [[HubSyncService alloc] init];
    });
    return _service;
}

-(id)init {
    self = [super init];
    if (self) {
        _coursesSyncInProgress = NO;
    }
    return self;
}

-(BOOL)coursesSyncInProgress {
    return _coursesSyncInProgress;
}

-(void)syncCourses {
    if (_coursesSyncInProgress) {
        return;
    }
    _coursesSyncInProgress = YES;
    _courses = [NSMutableDictionary dictionary];

    NSLog(@"%@", [[HubClient hubClient] sessionId]);

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoHubSyncServiceCoursesSyncBegin object:self];
    });
    
    [self fetchCourseList:0 limit:50];
}

-(void)syncManifest:(NSString *)courseId {
    if (!courseId) {
        return;
    }
    [[HubClient hubClient] getManifest:courseId callback:^(HubManifest *hubManifest) {
        NSManagedObjectContext *managedObjectContext = [[DataManager dataManager] newPrivateQueueManagedObjectContext];
        [managedObjectContext performBlock:^{
            Manifest *manifest = [[DataManager dataManager] getManifestByCourseId:hubManifest.courseId withManagedObjectContext:managedObjectContext];
            if (manifest == nil) {
                manifest = [[DataManager dataManager] insertNewManifestInManagedObjectContext:managedObjectContext];
            }
            [manifest syncWithHubManifest:hubManifest];
            [[DataManager dataManager] saveManagedObjectContext:managedObjectContext];
        }];
    }];
}

-(void)fetchCourseList:(NSInteger)start limit:(NSInteger)limit {
    [[HubClient hubClient] getCoursesStartingAt:start withLimit:limit andCallback:^(NSArray *courses, BOOL hasMore, NSInteger start, NSInteger limit) {
        if (courses != nil) {
            for (HubCourse *course in courses) {
                [_courses setObject:course forKey:course.courseId];
            }
        }
        
        if (hasMore) {
            [self fetchCourseList:start limit:limit];
        }
        else {
            [self processCourses];
        }
    }];
}

-(void)processCourses {
    NSManagedObjectContext *managedObjectContext = [[DataManager dataManager] newPrivateQueueManagedObjectContext];
    
    [managedObjectContext performBlockAndWait:^{
        NSArray *existingCourses = [[DataManager dataManager] getAllCoursesWithManagedObjectContext:managedObjectContext];
        for (Course *course in existingCourses) {
            HubCourse *hubCourse = [_courses objectForKey:course.courseId];
            if (hubCourse) {
                [course syncWithHubCourse:hubCourse];
                [_courses removeObjectForKey:course.courseId];
                [self syncManifest:[course courseId]];
            }
            else {
                [managedObjectContext deleteObject:course];
            }
        }
        [_courses enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Course *course = [[DataManager dataManager] insertNewCourseInManagedObjectContext:managedObjectContext];
            [course syncWithHubCourse:(HubCourse *)obj];
            [self syncManifest:[course courseId]];
        }];
        
        [[DataManager dataManager] saveManagedObjectContext:managedObjectContext];
    }];
    _courses = nil;
    _coursesSyncInProgress = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoHubSyncServiceCoursesSyncEnd object:self];
    });
}

@end
