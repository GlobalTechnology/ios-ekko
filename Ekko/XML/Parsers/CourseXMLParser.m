//
//  CourseXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CourseXMLParser.h"

#import "CourseManager.h"
#import "CoreDataManager.h"

@implementation CourseXMLParser

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementCourse]) {
        NSString *courseId = [attributeDict objectForKey:kEkkoCloudXMLAttrCourseId];
        NSNumber *courseVersion = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEkkoCloudXMLAttrCourseVersion] integerValue]];

        self.course = [CourseManager getCourseById:courseId withManagedObjectContext:self.managedObjectContext];
        if (self.course == nil) {
            self.course = (Course *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:self.managedObjectContext];
        }
        self.newVersion = ([courseVersion intValue] > [self.course.courseVersion intValue]) ? YES : NO;

        // Begin parsing the course - we handle delegates here since we can't call the normal XMLModel init inside a CoreData object
        [self.course setParentDelegate:parser.delegate];
        [parser setDelegate:self.course];
        [self.course ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}

@end
