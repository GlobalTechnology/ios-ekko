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
#import "Banner+Ekko.h"
#import "CoreDataManager.h"

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

    self.courseTitle = nil;
    self.courseDescription = nil;
    self.courseCopyright = nil;
    self.authorName = nil;
    self.authorEmail = nil;
    self.authorUrl = nil;
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
            permission = (Permission *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityPermission
                                                                          inManagedObjectContext:[(CoursesXMLParser *)parser managedObjectContext]];
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
    else if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaCopyright]) {
        self.courseCopyright = [(EkkoXMLParser *)parser appendString:string toString:self.courseCopyright];
    }
    else if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaAuthorName]) {
        self.authorName = [(EkkoXMLParser *)parser appendString:string toString:self.authorName];
    }
    else if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaAuthorEmail]) {
        self.authorEmail = [(EkkoXMLParser *)parser appendString:string toString:self.authorEmail];
    }
    else if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaAuthorURL]) {
        self.authorUrl = [(EkkoXMLParser *)parser appendString:string toString:self.authorUrl];
    }
}

-(void)ekkoXMLParser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kEkkoCloudXMLElementCourse]) {
        if (self.bannerId) {
            NSSet *resources = [[(CoursesXMLParser *)parser resources] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"resourceId LIKE[c] %@", self.bannerId]];
            if (resources && [resources count] > 0) {
                Resource *resource = (Resource *)[resources anyObject];
                Banner *banner = self.banner;
                if (banner == nil) {
                    banner = (Banner *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityBanner
                                                                          inManagedObjectContext:[(CoursesXMLParser *)parser managedObjectContext]];
                    self.banner = banner;
                }

                banner.bannerId = resource.resourceId;
                banner.type     = resource.type;
                banner.provider = resource.provider;
                banner.sha1     = resource.sha1;
                banner.size     = [NSNumber numberWithUnsignedLongLong:resource.size];
                banner.mimeType = resource.mimeType;
                banner.uri      = resource.uri;
                banner.videoId  = resource.videoId;
                banner.refId    = resource.refId;
            }
        }
    }
}

@end
