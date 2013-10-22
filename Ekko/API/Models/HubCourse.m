//
//  HubCourse.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/4/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubCourse.h"

@implementation HubCourse

@synthesize resources = _resources;

-(NSMutableArray *)resources {
    if (!_resources) {
        _resources = [NSMutableArray array];
    }
    return _resources;
}

-(HubResource *)bannerResource {
    NSString *bannerId = [[self courseMeta] bannerId];
    for (HubResource *resource in [self resources]) {
        if ([[resource resourceId] isEqualToString:bannerId]) {
            return resource;
        }
    }
    return nil;
}

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementCourse]) {
        [self setSchemaVersion:[[attributeDict objectForKey:kEkkoHubXMLAttrSchemaVersion] integerValue]];
        [self setCourseId:[attributeDict objectForKey:kEkkoHubXMLAttrCourseId]];
        [self setCourseVersion:[[attributeDict objectForKey:kEkkoHubXMLAttrCourseVersion] integerValue]];
        [self setCourseIsPublic:[[attributeDict objectForKey:kEkkoHubXMLAttrCoursePublic] boolValue]];
        [self setEnrollmentType:[attributeDict objectForKey:kEkkoHubXMLAttrCourseEnrollmentType]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementPermission]) {
        [self setPermission:[[HubPermission alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementMeta]) {
        [self setCourseMeta:[[HubMeta alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementResource]) {
        [[self resources] addObject:[[HubResource alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
}

@end
