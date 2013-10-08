//
//  HubManifest.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubManifest.h"

@implementation HubManifest

@synthesize courseId      = _courseId;
@synthesize courseVersion = _courseVersion;
@synthesize courseMeta    = _courseMeta;
@synthesize resources     = _resources;
@synthesize content       = _content;
@synthesize completeMessage = _completeMessage;

-(NSMutableArray *)content {
    if (!_content) {
        _content = [NSMutableArray array];
    }
    return _content;
}

-(NSMutableArray *)resources {
    if (!_resources) {
        _resources = [NSMutableArray array];
    }
    return _resources;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementManifest]) {
        [self setSchemaVersion:[[attributeDict objectForKey:kEkkoHubXMLAttrSchemaVersion] integerValue]];
        [self setCourseId:[attributeDict objectForKey:kEkkoHubXMLAttrCourseId]];
        [self setCourseVersion:[[attributeDict objectForKey:kEkkoHubXMLAttrCourseVersion] integerValue]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementMeta]) {
        [self setCourseMeta:[[HubMeta alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementResource]) {
        [[self resources] addObject:[[HubResource alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementContentLesson]) {
        [[self content] addObject:[[HubLesson alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementContentQuiz]) {
        [[self content] addObject:[[HubQuiz alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentElement] isEqualToString:kEkkoHubXMLElementCompletionMessage]) {
        [self setCompleteMessage:[self appendString:string toString:[self completeMessage]]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    [self parser:parser foundCharacters:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
}

@end
