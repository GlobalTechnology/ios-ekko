//
//  EkkoCloudClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/28/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

FOUNDATION_EXPORT NSString *const EkkoCloudClientDidEstablishSessionNotification;

@interface EkkoCloudClient : AFHTTPRequestOperationManager

@property (nonatomic, strong, readonly) NSString *guid;

+(EkkoCloudClient *)sharedClientForGUID:(NSString *)guid;
+(EkkoCloudClient *)sharedClient;

#pragma mark - Course List
-(void)getCoursesStartingAt:(NSInteger)start
                  withLimit:(NSInteger)limit
              completeBlock:(void(^)(NSData *coursesData, NSError *error))complete;

#pragma mark - Manifest
-(void)getManifest:(NSString *)courseId
     completeBlock:(void (^)(NSData *manifestData, NSError *error))complete;

#pragma mark - Resource
-(void)getResource:(NSString *)courseId
              sha1:(NSString *)sha1
     completeBlock:(void (^)(NSData *data))complete;

-(void)getResource:(NSString *)courseId
              sha1:(NSString *)sha1
      outputStream:(NSOutputStream *)outputStream
     progressBlock:(void (^)(float progress))progress
     completeBlock:(void (^)())complete;

#pragma mark - Course
-(void)getCourse:(NSString *)courseId
   completeBlock:(void (^)(NSData *courseData, NSError *error))complete;

#pragma mark - Course Permissions
-(void)enrollInCourse:(NSString *)courseId
        completeBlock:(void (^)(NSData *courseData, NSError *error))complete;

-(void)unenrollFromCourse:(NSString *)courseId
            completeBlock:(void (^)(NSData *courseData, NSError *error))complete;

#pragma mark - Ekko Cloud Video
-(void)getVideoStreamURL:(NSString *)courseId
                 videoId:(NSString *)videoId
           completeBlock:(void(^)(NSURL *videoStreamUrl))complete;

-(void)getVideoThumbnailURL:(NSString *)courseId
                    videoId:(NSString *)videoId
              completeBlock:(void(^)(NSURL *videoThumbnailUrl))complete;

-(void)getVideoDownloadURL:(NSString *)courseId
                   videoId:(NSString *)videoId
             completeBlock:(void(^)(NSURL *videoDownloadUrl))complete;

@end
