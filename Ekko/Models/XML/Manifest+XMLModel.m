//
//  Manifest+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Manifest+XMLModel.h"
#import "Resource+XMLModel.h"
#import "Lesson+XMLModel.h"
#import "Quiz+XMLModel.h"
#import "ManifestXMLParser.h"

@implementation Manifest (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementManifest)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.courseId      = attributeDict[kEkkoCloudXMLAttrCourseId];
    self.courseVersion = [attributeDict[kEkkoCloudXMLAttrCourseVersion] integerValue];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [(EkkoXMLParser *)parser parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementResource]) {
        Resource *resource = [[Resource alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                             element:elementName
                                                        namespaceURI:namespaceURI
                                                       qualifiedName:qName
                                                          attributes:attributeDict];
        resource.courseId = [(ManifestXMLParser *)parser manifest].courseId;
        [self.resources addObject:resource];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementContentLesson]) {
        [self.content addObject:[[Lesson alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                              element:elementName
                                                         namespaceURI:namespaceURI
                                                        qualifiedName:qName
                                                           attributes:attributeDict]];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementContentQuiz]) {
        [self.content addObject:[[Quiz alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                            element:elementName
                                                       namespaceURI:namespaceURI
                                                      qualifiedName:qName
                                                         attributes:attributeDict]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementMetaTitle]) {
        self.courseTitle = [(EkkoXMLParser *)parser appendString:string toString:[self courseTitle]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementCompletionMessage]) {
        self.completeMessage = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }
}

@end
