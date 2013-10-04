//
//  HubSyncService.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubSyncService.h"
#import "CoreDataService.h"
#import "HubClient.h"

#import "HubClient.h"

#import "Course+Hub.h"
#import "Manifest+Hub.h"

NSString *const EkkoHubSyncServiceCoursesSyncBegin = @"org.ekkoproject.ios.player.HubSyncServiceCoursesSyncBegin";
NSString *const EkkoHubSyncServiceCoursesSyncEnd = @"org.ekkoproject.ios.player.HubSyncServiceCoursesSyncEnd";

@interface HubSyncService () {
    BOOL _coursesSyncInProgress;
    NSMutableArray *_courses;
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
    _courses = [NSMutableArray array];

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
        dispatch_async(dispatch_get_main_queue(), ^{
            Manifest *manifest = [[CoreDataService sharedService] getManifestObjectByCourseId:[hubManifest courseId]];
            if (manifest == nil) {
                manifest = [[CoreDataService sharedService] newManifestObject];
            }
            [manifest updateWithHubManifest:hubManifest];
            if ([manifest hasChanges]) {
                [[CoreDataService sharedService] saveContext];
            }
        });
    }];
}

-(void)fetchCourseList:(NSInteger)start limit:(NSInteger)limit {
    [[HubClient hubClient] getCoursesStartingAt:start withLimit:limit andCallback:^(NSArray *courses, BOOL hasMore, NSInteger start, NSInteger limit) {
        if (courses != nil) {
            [_courses addObjectsFromArray:courses];
        }
        
        if (hasMore) {
            [self fetchCourseList:start limit:limit];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processCourses];
            });
        }
    }];
}

-(void)processCourses {
    NSMutableDictionary *existing = [NSMutableDictionary dictionary];

    NSArray *courses = [[CoreDataService sharedService] getAllCourseObjects];
    for (Course *course in courses) {
        [course setAccessible:NO];
        [existing setObject:course forKey:[course courseId]];
    }

    for (HubCourse *hubCourse in _courses) {
        Course *course = [existing objectForKey:[hubCourse courseId]];
        if (course == nil) {
            course = [[CoreDataService sharedService] newCourseObject];
        }
        [course updateWithHubCourse:hubCourse];
        if ([course hasChanges]) {
            [self syncManifest:[course courseId]];
        }
        [course setAccessible:YES];
    }

    [[CoreDataService sharedService] saveContext];
    _courses = nil;
    _coursesSyncInProgress = NO;

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoHubSyncServiceCoursesSyncEnd object:self];
    });
}

@end
