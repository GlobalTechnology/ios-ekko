//
//  Course+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Course+XMLModel.h"
#import "Course+Ekko.h"
#import "CoursesXMLParser.h"
#import "Permission+XMLModel.h"

#import "Resource+XMLModel.h"

@implementation Course (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementCourse)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.courseId = [attributeDict objectForKey:kEkkoCloudXMLAttrCourseId];
    self.courseVersion = [NSNumber numberWithInteger:[[attributeDict objectForKey:kEkkoCloudXMLAttrCourseVersion] integerValue]];
    self.public = [[attributeDict objectForKey:kEkkoCloudXMLAttrCoursePublic] boolValue];

    NSString *enrollmentType = [attributeDict objectForKey:kEkkoCloudXMLAttrCourseEnrollmentType];
    if ([enrollmentType isEqualToString:kEkkoCloudXMLValueEnrollmentTypeDisabled]) {
        self.enrollmentType = CourseEnrollmentDisabled;
    }
    else if ([enrollmentType isEqualToString:kEkkoCloudXMLValueEnrollmentTypeOpen]) {
        self.enrollmentType = CourseEnrollmentOpen;
    }
    else if ([enrollmentType isEqualToString:kEkkoCloudXMLValueEnrollmentTypeApproval]) {
        self.enrollmentType = CourseEnrollmentApproval;
    }
    else {
        self.enrollmentType = CourseEnrollmentUnknown;
    }
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [(EkkoXMLParser *)parser parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementMetaBanner]) {
        self.bannerId = [attributeDict objectForKey:kEkkoCloudXMLAttrResource];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementResource]) {
        Resource *resource = [[Resource alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                             element:elementName
                                                        namespaceURI:namespaceURI
                                                       qualifiedName:qName
                                                          attributes:attributeDict];
        // Add resource to temporary store
        [[(CoursesXMLParser *)parser resources] addObject:resource];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementPermission]) {
        NSString *guid = [attributeDict objectForKey:kEkkoCloudXMLAttrPermissionGuid];
        Permission *permission = [self permissionForGUID:guid];
        if (permission == nil) {
            permission = [[(CoursesXMLParser *)parser courseDelegate] newPermission];
            [self addPermissionsObject:permission];
        }

        if (permission) {
            [permission setParentDelegate:parser.delegate];
            [parser setDelegate:permission];
            [permission ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaTitle]) {
        self.courseTitle = [(EkkoXMLParser *)parser appendString:string toString:self.courseTitle];
    }
    else if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaDescription]) {
        self.courseDescription = [(EkkoXMLParser *)parser appendString:string toString:self.courseDescription];
    }
}

-(void)ekkoXMLParser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kEkkoCloudXMLElementCourse] && self.bannerId) {
        NSSet *resource = [[(CoursesXMLParser *)parser resources] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"resourceId LIKE[c] %@", self.bannerId]];
        if (resource && [resource count] > 0) {
            Resource *banner = (Resource *)[resource anyObject];
            self.bannerSha1 = banner.sha1;
            self.bannerSize = [NSNumber numberWithUnsignedLongLong:banner.size];
            self.bannerMimeType = banner.mimeType;
        }
    }
}

@end
