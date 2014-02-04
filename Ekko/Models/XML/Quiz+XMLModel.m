//
//  Quiz+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Quiz+XMLModel.h"
#import "ManifestXMLParser.h"
#import "MultipleChoice+XMLModel.h"

@implementation Quiz (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementContentQuiz)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.quizId = [attributeDict objectForKey:kEkkoCloudXMLAttrQuizId];
    self.title  = [attributeDict objectForKey:kEkkoCloudXMLAttrQuizTitle];

    //Set Parent Manifest
    self.manifest = [(ManifestXMLParser *)parser manifest];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoCloudXMLElementQuizQuestion]) {
        NSString *type = [attributeDict objectForKey:kEkkoCloudXMLAttrQuestionType];
        if([type isEqualToString:kEkkoCloudXMLValueQuestionTypeMultipleChoice]) {
            MultipleChoice *question = [[MultipleChoice alloc] initWithEkkoXMLParser:(EkkoXMLParser *)parser
                                                                             element:elementName
                                                                        namespaceURI:namespaceURI
                                                                       qualifiedName:qName
                                                                          attributes:attributeDict];
            question.quiz = self;
            [self.questions addObject:question];
        }
    }
}

@end
