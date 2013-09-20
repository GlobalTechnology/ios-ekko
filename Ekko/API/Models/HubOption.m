//
//  HubOption.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubOption.h"

@implementation HubOption

@synthesize optionId   = _optionId;
@synthesize optionText = _optionText;
@synthesize isAnswer   = _isAnswer;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementQuizQuestionOption]) {
        [self setOptionId:[attributeDict objectForKey:kEkkoHubXMLAttrOptionId]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentElement] isEqualToString:kEkkoHubXMLElementQuizQuestionOption]) {
        [self setOptionText:[self appendString:string toString:[self optionText]]];
    }
}

@end
