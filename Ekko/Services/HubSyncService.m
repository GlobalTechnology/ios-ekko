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

    NSLog(@"%@", [[HubClient sharedClient] sessionId]);

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoHubSyncServiceCoursesSyncBegin object:self];
    });
    
    [[HubClient sharedClient] getCourses:self];
}

-(void)syncManifest:(NSString *)courseId {
    if (!courseId) {
        return;
    }
    [[HubClient sharedClient] getCourseManifest:courseId delegate:self];
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
//            [[HubClient sharedClient] getCourseResource:course.courseId sha1:[[[course resources] anyObject] sha1] completionHandler:^(NSData *data) {
//                UIImage *banner = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
//                [course setBanner:UIImagePNGRepresentation(banner)];
//            }];
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

#pragma mark - HubClientCoursesDelegate

-(void)hubClientCourses:(NSArray *)courses hasMore:(BOOL)hasMore start:(NSInteger)start limit:(NSInteger)limit {
    if (!_coursesSyncInProgress) {
        return;
    }

    [_courses addObjectsFromArray:courses];

    //If more courses are available, fetch the next batch
    if (hasMore) {
        [[HubClient sharedClient] getCoursesStartingAt:start+limit withLimit:limit delegate:self];
    }
    //otherwise, process the courses
    else {
        [self processCourses];
    }
}

#pragma mark - HubClientManifestDelegate

-(void)hubClientManifest:(HubManifest *)hubManifest {
    Manifest *manifest = [[CoreDataService sharedService] getManifestObjectByCourseId:[hubManifest courseId]];
    if (manifest == nil) {
        manifest = [[CoreDataService sharedService] newManifestObject];
    }
    [manifest updateWithHubManifest:hubManifest];
    if ([manifest hasChanges]) {
        [[CoreDataService sharedService] saveContext];
    }
}

@end
