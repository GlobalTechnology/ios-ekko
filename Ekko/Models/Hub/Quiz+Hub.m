//
//  Quiz+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Quiz+Hub.h"
#import "HubQuestionMC.h"
#import "CoreDataService.h"
#import "MultipleChoice+Hub.h"

@implementation Quiz (Hub)

-(void)addQuestionsObject:(Question *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.questions];
    [orderedSet addObject:value];
    self.questions = orderedSet;
}

-(void)updateWithHubQuiz:(HubQuiz *)hubQuiz {
    [self setItemId:[hubQuiz quizId]];
    [self setItemTitle:[hubQuiz quizTitle]];
    
    self.questions = [NSMutableOrderedSet orderedSet];
    for (HubQuestion *hubQuestion in hubQuiz.questions) {
        if ([hubQuestion isKindOfClass:[HubQuestionMC class]]) {
            MultipleChoice *question = [[CoreDataService sharedService] newMultipleChoiceObject];
            [question setQuestionId:[hubQuestion questionId]];
            [question setQuestionText:[(HubQuestionMC *)hubQuestion questionText]];
            
            question.options = [NSMutableOrderedSet orderedSet];
            for (HubOption *hubOption in [(HubQuestionMC *)hubQuestion options]) {
                MultipleChoiceOption *option = [[CoreDataService sharedService] newMultipleChoiceOptionObject];
                [option setOptionId:[hubOption optionId]];
                [option setOptionText:[hubOption optionText]];
                [option setIsAnswer:[hubOption isAnswer]];
                [question addOptionsObject:option];
            }
            
            [self addQuestionsObject:question];
        }
    }
}

@end
