//
//  HubMeta.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubMeta.h"

@implementation HubMeta

@synthesize courseTitle       = _courseTitle;
@synthesize authorName        = _authorName;
@synthesize authorEmail       = _authorEmail;
@synthesize authorUrl         = _authorUrl;
@synthesize courseDescription = _courseDescription;
@synthesize courseCopyright   = _courseCopyright;
@synthesize bannerId          = _bannerId;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementMetaBanner]) {
        [self setBannerId:[attributeDict objectForKey:kEkkoHubXMLAttrResource]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaTitle]) {
        [self setCourseTitle:[self appendString:string toString:[self courseTitle]]];
    }
    else if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaAuthorName]) {
        [self setAuthorName:[self appendString:string toString:[self authorName]]];
    }
    else if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaAuthorEmail]) {
        [self setAuthorEmail:[self appendString:string toString:[self authorEmail]]];
    }
    else if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaAuthorURL]) {
        [self setAuthorUrl:[self appendString:string toString:[self authorUrl]]];
    }
    else if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaDescription]) {
        [self setCourseDescription:[self appendString:string toString:[self courseDescription]]];
    }
    else if ([[self currentElement] isEqualToString:kEkkoHubXMLElementMetaCopyright]) {
        [self setCourseCopyright:[self appendString:string toString:[self courseCopyright]]];
    }
}

@end
