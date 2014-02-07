//
//  CoursesXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoursesXMLParser.h"

@implementation CoursesXMLParser

@synthesize resources = _resources;

-(NSMutableSet *)resources {
    if (!_resources) {
        _resources = [NSMutableSet set];
    }
    return _resources;
}

-(id)initWithData:(NSData *)data andDelegate:(id<CoursesXMLParserDelegate>)delegate {
    self = [super initWithData:data];
    if (!self) {
        return nil;
    }
    self.courseDelegate = delegate;
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementCourses]) {
        self.start   = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesStart] integerValue];
        self.limit   = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesLimit] integerValue];
        self.hasMore = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesHasMore] boolValue];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementCourse]) {
        // Set Course schema version
        self.schemaVersion = [[attributeDict objectForKey:kEkkoCloudXMLAttrSchemaVersion] integerValue];

        // Empty temporary resources set
        [self.resources removeAllObjects];

        NSString *courseId = [attributeDict objectForKey:kEkkoCloudXMLAttrCourseId];
        [self.courseDelegate foundCourse:courseId];
        Course *course = [self.courseDelegate fetchCourse:courseId];
        [course setParentDelegate:parser.delegate];
        [parser setDelegate:course];
        [course ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}

@end
