//
//  Lesson+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Lesson+XMLModel.h"
#import "ManifestXMLParser.h"
#import "Media+XMLModel.h"
#import "Page+XMLModel.h"

@implementation Lesson (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementContentLesson)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.lessonId = [attributeDict objectForKey:kEkkoCloudXMLAttrLessonId];
    self.title    = [attributeDict objectForKey:kEkkoCloudXMLAttrLessonTitle];

    //Set Parent Manifest
    self.manifest = [(ManifestXMLParser *)parser manifest];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoCloudXMLElementLessonMedia]) {
        [self.media addObject:[[Media alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                           element:elementName
                                                      namespaceURI:namespaceURI
                                                     qualifiedName:qName
                                                        attributes:attributeDict]];
    }
    else if ([elementName isEqualToString:kEkkoCloudXMLElementLessonText]) {
        [self.pages addObject:[[Page alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                          element:elementName
                                                     namespaceURI:namespaceURI
                                                    qualifiedName:qName
                                                       attributes:attributeDict]];
    }
}

@end
