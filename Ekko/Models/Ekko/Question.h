//
//  Question.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quiz.h"

typedef NS_ENUM(NSUInteger, EkkoQuestionType) {
    EkkoQuestionTypeUnknown        = 0,
    EkkoQuestionTypeMultipleChoice = 1,
};

@interface Question : NSObject

@property (nonatomic, readonly) NSString *courseId;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, readonly) EkkoQuestionType questionType;
@property (nonatomic, weak) Quiz *quiz;

@end
