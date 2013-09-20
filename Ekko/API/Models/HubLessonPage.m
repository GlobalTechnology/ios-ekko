//
//  HubLessonPage.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubLessonPage.h"

@implementation HubLessonPage

@synthesize pageId   = _pageId;
@synthesize pageText = _pageText;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementLessonText]) {
        [self setPageId:[attributeDict objectForKey:kEkkoHubXMLAttrTextId]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentElement] isEqualToString:kEkkoHubXMLElementLessonText]) {
        [self setPageText:[self appendString:string toString:[self pageText]]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    [self parser:parser foundCharacters:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
}

@end
