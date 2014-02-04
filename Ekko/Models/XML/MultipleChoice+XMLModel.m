//
//  MultipleChoice+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "MultipleChoice+XMLModel.h"
#import "MultipleChoiceOption+XMLModel.h"

@implementation MultipleChoice (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementQuizQuestion)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.questionId = [attributeDict objectForKey:kEkkoCloudXMLAttrQuestionId];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoCloudXMLElementQuizQuestionOption]) {
        MultipleChoiceOption *option = [[MultipleChoiceOption alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                                                   element:elementName
                                                                              namespaceURI:namespaceURI
                                                                             qualifiedName:qName
                                                                                attributes:attributeDict];
        option.question = self;
        [self.options addObject:option];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if ([[(EkkoXMLParser *)parser currentElement] isEqualToString:kEkkoCloudXMLElementQuizQuestionText]) {
        self.questionText = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }
}

@end
