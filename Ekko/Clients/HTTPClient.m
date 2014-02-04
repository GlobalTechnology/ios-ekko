//
//  HTTPClient.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "HTTPClient.h"

@implementation HTTPClient

+(HTTPClient *)sharedClient {
    __strong static HTTPClient *_httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpClient = [[HTTPClient alloc] init];
    });
    return _httpClient;
}

@end
