//
//  QuizManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "QuizManager.h"
#import <TheKeyOAuth2Client.h>
#import "CoreDataManager.h"

#import "Quiz.h"
#import "Question.h"
#import "MultipleChoice.h"
#import "Answer.h"

@interface QuizManager ()
@property (nonatomic, strong, readwrite) NSString *guid;
@end

@implementation QuizManager

+(QuizManager *)quizManagerForGUID:(NSString *)guid {
    __strong static NSMutableDictionary *_managers = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _managers = [NSMutableDictionary dictionary];
    });

    QuizManager *manager = nil;
    @synchronized(_managers) {
        guid = guid ?: [[TheKeyOAuth2Client sharedOAuth2Client] guid];
        manager = (QuizManager *)[_managers objectForKey:guid];
        if(manager == nil) {
            manager = [[QuizManager alloc] initWithGUID:guid];
            [_managers setObject:manager forKey:guid];
        }
    }
    return manager;
}

+(QuizManager *)quizManager {
    return [QuizManager quizManagerForGUID:nil];
}

-(id)initWithGUID:(NSString *)guid {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.guid = [guid copy];
    return self;
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
    NSManagedObjectContext *managedObjectContext = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityAnswer];
        [request setPredicate:[NSPredicate predicateWithFormat:@"guid = %@ AND courseId = %@ AND questionId = %@", self.guid, [option.question courseId], option.question.questionId]];
        NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
        if (results && results.count > 0) {
            Answer *answer = [results firstObject];
            if (![answer.answer isEqualToString:option.optionId]) {
                [answer setAnswer:option.optionId];
            }
        }
        else {
            Answer *answer = (Answer *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityAnswer inManagedObjectContext:managedObjectContext];
            [answer setGuid:self.guid];
            [answer setCourseId:[option.question courseId]];
            [answer setQuestionId:option.question.questionId];
            [answer setAnswer:option.optionId];
        }
        if ([managedObjectContext hasChanges]) {
            [[CoreDataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        }
    }];
}

-(NSString *)selectedMultipleChoiceAnswer:(MultipleChoice *)question {
    __block NSString *selected = nil;
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityAnswer];
        [request setPredicate:[NSPredicate predicateWithFormat:@"guid = %@ AND courseId = %@ AND questionId = %@", self.guid, [question courseId], question.questionId]];
        NSArray *results = [context executeFetchRequest:request error:nil];
        if (results && results.count > 0) {
            Answer *answer = (Answer *)[results firstObject];
            selected = [answer.answer copy];
        }
    }];
    return selected;
}

@end
