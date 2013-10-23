//
//  QuizManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "QuizManager.h"
#import "DataManager.h"
#import "Answer.h"

#import "Quiz+Ekko.h"
#import "Question+Ekko.h"
#import "MultipleChoice+Ekko.h"

@implementation QuizManager

+(QuizManager *)quizManager {
    __strong static QuizManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[QuizManager alloc] init];
    });
    return _manager;
}

-(NSUInteger)quizResults:(Quiz *)quiz {
    NSUInteger correct = 0;
    for (Question *question in quiz.questions) {
        if ([question isKindOfClass:[MultipleChoice class]]) {
            NSString *selectedAnswer = [self selectedMultipleChoiceAnswer:(MultipleChoice *)question];
            MultipleChoiceOption *answer = [(MultipleChoice *)question answer];
            if (selectedAnswer && answer && [answer.optionId isEqualToString:selectedAnswer]) {
                correct++;
            }
        }
    }
    return correct;
}

-(void)saveMultipleChoiceAnswer:(MultipleChoiceOption *)option {
    NSManagedObjectContext *managedObjectContext = [[DataManager dataManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        NSFetchRequest *request = [[DataManager dataManager] fetchRequestForEntity:EkkoEntityAnswer];
        [request setPredicate:[NSPredicate predicateWithFormat:@"courseId = %@ AND questionId = %@", [option.question courseId], option.question.questionId]];
        NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
        if (results && results.count > 0) {
            Answer *answer = [results firstObject];
            if (![answer.answer isEqualToString:option.optionId]) {
                [answer setAnswer:option.optionId];
            }
        }
        else {
            Answer *answer = (Answer *)[[DataManager dataManager] insertNewObjectForEntity:EkkoEntityAnswer inManagedObjectContext:managedObjectContext];
            [answer setCourseId:[option.question courseId]];
            [answer setQuestionId:option.question.questionId];
            [answer setAnswer:option.optionId];
        }
        if ([managedObjectContext hasChanges]) {
            [[DataManager dataManager] saveManagedObjectContext:managedObjectContext];
        }
    }];
}

-(NSString *)selectedMultipleChoiceAnswer:(MultipleChoice *)question {
    NSFetchRequest *request = [[DataManager dataManager] fetchRequestForEntity:EkkoEntityAnswer];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId = %@ AND questionId = %@", [question courseId], question.questionId]];
    NSArray *results = [question.managedObjectContext executeFetchRequest:request error:nil];
    if (results && results.count > 0) {
        Answer *answer = (Answer *)[results firstObject];
        return answer.answer;
    }
    return nil;
}

@end
