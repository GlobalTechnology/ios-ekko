//
//  HubClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AFHTTPClient.h"
#import "HubManifest.h"

@protocol HubClientCoursesDelegate;
@protocol HubClientManifestDelegate;

@interface HubClient : AFHTTPClient

@property (readonly, strong, nonatomic) NSMutableArray *pendingOperations;

+(HubClient *)sharedClient;

-(NSString *)sessionId;
-(NSString *)sessionGuid;
-(BOOL)hasSession;

-(NSURL *)URLWithSession:(BOOL)useSession endpoint:(NSString *)endpoint;

-(void)getCourses:(id<HubClientCoursesDelegate>)delegate;
-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit delegate:(id<HubClientCoursesDelegate>)delegate;

-(void)getCourseManifest:(NSString *)courseId delegate:(id<HubClientManifestDelegate>)delegate;

-(void)getCourseResource:(NSString *)courseId sha1:(NSString *)sha1 completionHandler:(void (^)(NSData *data))complete;

@end

@protocol HubClientCoursesDelegate <NSObject>
@required
-(void)hubClientCourses:(NSArray *)courses hasMore:(BOOL)hasMore start:(NSInteger)start limit:(NSInteger)limit;
@end

@protocol HubClientManifestDelegate <NSObject>
@required
-(void)hubClientManifest:(HubManifest *)hubManifest;
@end
