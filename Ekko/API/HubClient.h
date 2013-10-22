//
//  HubClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AFHTTPClient.h"
#import "HubCourse.h"
#import "HubManifest.h"

@interface HubClient : AFHTTPClient

@property (nonatomic, strong, readonly) NSString *sessionId;
@property (nonatomic, strong, readonly) NSString *sessionGuid;

+(HubClient *)hubClient;

-(BOOL)hasSession;

#pragma mark - Course List
-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit andCallback:(void (^)(NSArray *courses, BOOL hasMore, NSInteger start, NSInteger limit))callback;

#pragma mark - Manifest
-(void)getManifest:(NSString *)courseId callback:(void (^)(HubManifest *hubManifest))callback;

#pragma mark - Resource
-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 callback:(void (^)(NSData *data))callback;
-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 outputStream:(NSOutputStream *)outputStream progress:(void (^)(float progress))progress complete:(void (^)())complete;

#pragma mark - Course
-(void)getCourse:(NSString *)courseId callback:(void (^)(HubCourse *course))callback;

#pragma mark - Course Permissions
-(void)enrollInCourse:(NSString *)courseId callback:(void (^)(HubCourse *course))callback;
-(void)unenrollFromCourse:(NSString *)courseId callback:(void (^)(BOOL success))callback;

@end
