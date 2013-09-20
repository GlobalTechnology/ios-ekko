//
//  HubHTTPRequestOperation.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/16/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface HubHTTPRequestOperation : AFHTTPRequestOperation

@property (nonatomic) BOOL useSession;
@property (nonatomic, strong) NSString *endpoint;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) void (^success)(AFHTTPRequestOperation *operation, id responseObject);
@property (nonatomic, copy) void (^failure)(AFHTTPRequestOperation *operation, NSError *error);
-(void)setHubParameters:(BOOL)useSession endpoint:(NSString *)endpoint parameters:(NSDictionary *)paramters;
-(void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
