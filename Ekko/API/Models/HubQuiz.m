//
//  HubQuiz.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubQuiz.h"

@implementation HubQuiz

@synthesize quizId    = _quizId;
@synthesize quizTitle = _quizTitle;
@synthesize questions = _questions;

-(NSMutableArray *)questions {
    if (!_questions) {
        _questions = [NSMutableArray array];
    }
    return _questions;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementContentQuiz]) {
        [self setQuizId:[attributeDict objectForKey:kEkkoHubXMLAttrQuizId]];
        [self setQuizTitle:[attributeDict objectForKey:kEkkoHubXMLAttrQuizTitle]];
    }
    else if ([elementName isEqualToString:kEkkoHubXMLElementQuizQuestion]) {
        if ([@"multiple" isEqualToString:[attributeDict objectForKey:kEkkoHubXMLAttrQuestionType]]) {
            [[self questions] addObject:[[HubQuestionMC alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
        }
    }
}

@end
