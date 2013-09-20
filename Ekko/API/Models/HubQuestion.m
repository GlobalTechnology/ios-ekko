//
//  HubQuestion.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubQuestion.h"

@implementation HubQuestion

@synthesize questionId   = _questionId;
@synthesize questionType = _questionType;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementQuizQuestion]) {
        [self setQuestionId:[attributeDict objectForKey:kEkkoHubXMLAttrQuestionId]];
        [self setQuestionType:[attributeDict objectForKey:kEkkoHubXMLAttrQuestionType]];
    }
}

@end
