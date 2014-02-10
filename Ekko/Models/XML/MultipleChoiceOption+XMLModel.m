//
//  MultipleChoiceOption+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "MultipleChoiceOption+XMLModel.h"

@implementation MultipleChoiceOption (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementQuizQuestionOption)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.optionId   = [attributeDict objectForKey:kEkkoCloudXMLAttrOptionId];
    self.isAnswer   = ([attributeDict objectForKey:kEkkoCloudXMLAttrOptionAnswer] != nil) ? YES : NO;
    self.optionText = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.optionText = [(EkkoXMLParser *)parser appendString:string toString:self.optionText];
}

@end
