//
//  QuizManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleChoiceOption.h"
#import "MultipleChoice.h"
#import "Quiz.h"

@interface QuizManager : NSObject

@property (nonatomic, strong, readonly) NSString *guid;

+(QuizManager *)quizManagerForGUID:(NSString *)guid;
+(QuizManager *)quizManager;

-(NSUInteger)quizResults:(Quiz *)quiz;
-(void)saveMultipleChoiceAnswer:(MultipleChoiceOption *)option;
-(NSString *)selectedMultipleChoiceAnswer:(MultipleChoice *)question;

@end
