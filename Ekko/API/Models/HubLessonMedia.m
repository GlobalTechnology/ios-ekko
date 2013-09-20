//
//  HubLessonMedia.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubLessonMedia.h"

@implementation HubLessonMedia

@synthesize mediaId     = _mediaId;
@synthesize mediaType   = _mediaType;
@synthesize resourceId  = _resourceId;
@synthesize thumbnailId = _thumbnailId;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementLessonMedia]) {
        [self setMediaId:[attributeDict objectForKey:kEkkoHubXMLAttrMediaId]];
        [self setMediaType:[attributeDict objectForKey:kEkkoHubXMLAttrMediaType]];
        [self setResourceId:[attributeDict objectForKey:kEkkoHubXMLAttrResource]];
        [self setThumbnailId:[attributeDict objectForKey:kEkkoHubXMLAttrThumbnail]];
    }
}

@end
