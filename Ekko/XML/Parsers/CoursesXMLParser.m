//
//  CoursesXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoursesXMLParser.h"

#import "CourseManager.h"
#import "CoreDataManager.h"

#import "Course+XMLModel.h"

@implementation CoursesXMLParser

@synthesize resources = _resources;

-(id)initWithData:(NSData *)data managedObjectContext:(NSManagedObjectContext *)managedObjectContext delegate:(id<CoursesXMLParserDelegate>)delegate {
    self = [super initWithData:data managedObjectContext:managedObjectContext];
    if (!self) {
        return nil;
    }
    self.courseDelegate = delegate;
    return self;
}

-(NSMutableSet *)resources {
    if (!_resources) {
        _resources = [NSMutableSet set];
    }
    return _resources;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementCourses]) {
        self.start   = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesStart] integerValue];
        self.limit   = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesLimit] integerValue];
        self.hasMore = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursesHasMore] boolValue];
    }
    // Found Course
    else if ([elementName isEqualToString:kEkkoCloudXMLElementCourse]) {
        // Set Course schema version
        self.schemaVersion = [[attributeDict objectForKey:kEkkoCloudXMLAttrSchemaVersion] integerValue];

        // Empty temporary resources set
        [self.resources removeAllObjects];

        // Find or insert new course
        NSString *courseId = [attributeDict objectForKey:kEkkoCloudXMLAttrCourseId];
        Course *course = [CourseManager getCourseById:courseId withManagedObjectContext:self.managedObjectContext];
        if (course == nil) {
            course = (Course *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:self.managedObjectContext];
        }

        // Notify of found course
        NSNumber *courseVersion = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEkkoCloudXMLAttrCourseVersion] integerValue]];
        BOOL isNewVersion = ([courseVersion intValue] > [course.courseVersion intValue]) ? YES : NO;
        [self.courseDelegate foundCourse:courseId isNewVersion:isNewVersion];

        // Begin parsing the course - we handle delegates here since we can't call the normal XMLModel init inside a CoreData object
        [course setParentDelegate:parser.delegate];
        [parser setDelegate:course];
        [course ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}

@end
