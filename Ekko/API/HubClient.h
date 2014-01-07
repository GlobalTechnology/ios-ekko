//
//  HubClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <AFNetworking.h>
#import "HubCourse.h"
#import "HubManifest.h"

typedef NS_ENUM(int16_t, EkkoCloudVideoURLType) {
    EkkoCloudVideoURLTypeDownload  = 0,
    EkkoCloudVideoURLTypeStream    = 1,
    EkkoCloudVideoURLTypeThumbnail = 2,
};

FOUNDATION_EXPORT NSString *const EkkoHubClientDidEstablishSessionNotification;

@interface HubClient : AFHTTPRequestOperationManager

@property (nonatomic, strong, readonly) NSString *sessionId;
@property (nonatomic, strong, readonly) NSString *sessionGuid;

+(HubClient *)sharedClient;

-(BOOL)hasSession;

#pragma mark - Course List
-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit callback:(void (^)(NSArray *courses, BOOL hasMore, NSInteger start, NSInteger limit))callback;

#pragma mark - Manifest
-(void)getManifest:(NSString *)courseId callback:(void (^)(HubManifest *hubManifest))callback;

#pragma mark - Resource
-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 callback:(void (^)(NSData *data))callback;
-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 outputStream:(NSOutputStream *)outputStream progress:(void (^)(float progress))progress complete:(void (^)())complete;

#pragma mark - Course
-(void)getCourse:(NSString *)courseId callback:(void (^)(HubCourse *hubCourse))callback;

#pragma mark - Course Permissions
-(void)enrollInCourse:(NSString *)courseId callback:(void (^)(HubCourse *hubCourse))callback;
-(void)unenrollFromCourse:(NSString *)courseId callback:(void (^)(HubCourse *hubCourse))callback;

#pragma mark - Ekko Cloud Video
-(void)getECVResourceURL:(NSString *)courseId videoId:(NSString *)videoId urlType:(EkkoCloudVideoURLType)urlType complete:(void(^)(NSURL *videoURL))complete;

@end
