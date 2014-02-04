//
//  ArclightClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/24/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ArclightClient : AFHTTPRequestOperationManager

+(ArclightClient *)sharedClient;

-(void)getThumbnailURL:(NSString *)refId complete:(void(^)(NSURL *thumbnailURL))complete;
-(void)getVideoStreamUrl:(NSString *)refId complete:(void(^)(NSURL *videoStreamUrl))complete;

@end
