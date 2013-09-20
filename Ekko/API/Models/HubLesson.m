//
//  HubLesson.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubLesson.h"
#import "HubLessonMedia.h"
#import "HubLessonPage.h"

@implementation HubLesson

@synthesize lessonId    = _lessonId;
@synthesize lessonTitle = _lessonTitle;
@synthesize media       = _media;
@synthesize pages       = _pages;

-(NSMutableArray *)media {
    if (!_media) {
        _media = [NSMutableArray array];
    }
    return _media;
}

-(NSMutableArray *)pages {
    if (!_pages) {
        _pages = [NSMutableArray array];
    }
    return _pages;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementContentLesson]) {
        [self setLessonId:[attributeDict objectForKey:kEkkoHubXMLAttrLessonId]];
        [self setLessonTitle:[attributeDict objectForKey:kEkkoHubXMLAttrLessonTitle]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementLessonMedia]) {
        [[self media] addObject:[[HubLessonMedia alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementLessonText]) {
        [[self pages] addObject:[[HubLessonPage alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
}

@end
