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

-(void)syncWithHubResource:(HubResource *)hubResource {
    [self setResourceId:[hubResource resourceId]];
    
    if ([hubResource.resourceType isEqualToString:kEkkoHubXMLValueResourceTypeFile])
        [self setType:EkkoResourceTypeFile];
    else if ([hubResource.resourceType isEqualToString:kEkkoHubXMLValueResourceTypeURI])
        [self setType:EkkoResourceTypeURI];
    else if ([hubResource.resourceType isEqualToString:kEkkoHubXMLValueResourceTypeDynamic])
        [self setType:EkkoResourceTypeDynamic];
    else
        [self setType:EkkoResourceTypeUnknown];
    
    [self setSha1:[hubResource sha1]];
    [self setMimeType:[hubResource mimeType]];
    [self setSize:[hubResource size]];

    if (hubResource.provider == nil)
        [self setProvider:EkkoResourceProviderNone];
    else if ([hubResource.provider isEqualToString:kEkkoHubXMLValueResourceProviderYouTube])
        [self setProvider:EkkoResourceProviderYouTube];
    else if ([hubResource.provider isEqualToString:kEkkoHubXMLValueResourceProviderVimeo])
        [self setProvider:EkkoResourceProviderVimeo];
    else
        [self setProvider:EkkoResourceProviderUnknown];
    
    [self setUri:[hubResource uri]];
}

@end
