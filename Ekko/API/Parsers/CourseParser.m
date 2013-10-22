//
//  CourseParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/22/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseParser.h"

@implementation CourseParser

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoHubXMLElementCourse]) {
        int64_t schemaVersion = [[attributeDict objectForKey:kEkkoHubXMLAttrSchemaVersion] integerValue];
        [self setCourse:[[HubCourse alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:schemaVersion]];
    }
}

@end
