//
//  Resource+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource+Hub.h"
#import "Resource+Ekko.h"

@implementation Resource (Hub)

-(void)updateFromHubResource:(HubResource *)hubResource {
    [self setResourceId:[hubResource resourceId]];
    
    if ([[hubResource resourceType] isEqualToString:@"file"]) {
        [self setType:EkkoResourceTypeFile];
    }
    else if ([[hubResource resourceType] isEqualToString:@"uri"]) {
        [self setType:EkkoResourceTypeURI];
    }
    else if ([[hubResource resourceType] isEqualToString:@"dynamic"]) {
        [self setType:EkkoResourceTypeDynamic];
    }
    else {
        [self setType:EkkoResourceTypeUnknown];
    }
    
    [self setSha1:[hubResource sha1]];
    [self setMimeType:[hubResource mimeType]];
    [self setSize:[hubResource size]];

    if ([[hubResource provider] isEqualToString:@"youtube"]) {
        [self setProvider:EkkoResourceProviderYouTube];
    }
    else if ([[hubResource provider] isEqualToString:@"vimeo"]) {
        [self setProvider:EkkoResourceProviderVimeo];
    }
    else {
        [self setProvider:EkkoResourceProviderNone];
    }
    
    [self setUri:[hubResource uri]];
}

@end
