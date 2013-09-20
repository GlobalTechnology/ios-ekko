//
//  CoursesParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/5/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CoursesParser.h"
#import "HubCourse.h"

@implementation CoursesParser

@synthesize hasMore = _hasMore;
@synthesize start   = _start;
@synthesize limit   = _limit;
@synthesize courses = _courses;

-(id)init {
    self = [super init];
    if (self) {
        _hasMore = NO;
    }
    return self;
}

-(NSMutableArray *)courses {
    if (!_courses) {
        _courses = [NSMutableArray array];
    }
    return _courses;
}

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoHubXMLElementCourses]) {
        [self setHasMore:[[attributeDict objectForKey:kEkkoHubXMLAttrCoursesHasMore] boolValue]];
        [self setStart:[[attributeDict objectForKey:kEkkoHubXMLAttrCoursesStart] integerValue]];
        [self setLimit:[[attributeDict objectForKey:kEkkoHubXMLAttrCoursesLimit] integerValue]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementCourse]) {
        int64_t schemaVersion = [[attributeDict objectForKey:kEkkoHubXMLAttrSchemaVersion] integerValue];
        [[self courses] addObject:[[HubCourse alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:schemaVersion]];
    }
}

@end
