//
//  HubResource.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubResource.h"

@implementation HubResource

@synthesize resourceId    = _resourceId;
@synthesize resourceType  = _resourceType;
@synthesize size          = _size;
@synthesize sha1          = _sha1;
@synthesize mimeType      = _mimeType;
@synthesize provider      = _provider;
@synthesize uri           = _uri;
@synthesize videoId       = _videoId;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementResource]) {
        [self setResourceId:[attributeDict objectForKey:kEkkoHubXMLAttrResourceId]];
        [self setResourceType:[attributeDict objectForKey:kEkkoHubXMLAttrResourceType]];
        [self setSize:[[attributeDict objectForKey:kEkkoHubXMLAttrResourceSize] integerValue]];
        [self setSha1:[attributeDict objectForKey:kEkkoHubXMLAttrResourceSha1]];
        [self setMimeType:[attributeDict objectForKey:kEkkoHubXMLAttrResourceMimeType]];
        [self setProvider:[attributeDict objectForKey:kEkkoHubXMLAttrResourceProvider]];
        [self setUri:[attributeDict objectForKey:kEkkoHubXMLAttrResourceURI]];
        [self setVideoId:[attributeDict objectForKey:kEkkoHubXMLAttrResourceVideoId]];
    }
}

@end
