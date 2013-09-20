//
//  HubHTTPRequestOperation.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/16/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubHTTPRequestOperation.h"

@implementation HubHTTPRequestOperation

@synthesize useSession = _useSession;
@synthesize endpoint   = _endpoint;
@synthesize parameters = _parameters;
@synthesize success    = _success;
@synthesize failure    = _failure;

-(void)setHubParameters:(BOOL)useSession endpoint:(NSString *)endpoint parameters:(NSDictionary *)paramters {
    [self setUseSession:useSession];
    [self setEndpoint:endpoint];
    [self setParameters:paramters];
}

-(void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [self setSuccess:success];
    [self setFailure:failure];
    [super setCompletionBlockWithSuccess:success failure:failure];
}

+(BOOL)canProcessRequest:(NSURLRequest *)urlRequest {
    return YES;
}

@end
