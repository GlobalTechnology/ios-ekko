//
//  Question.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Question.h"

@implementation Question

-(EkkoQuestionType)questionType {
    return EkkoQuestionTypeUnknown;
}

-(NSString *)courseId {
    return self.quiz.manifest.courseId;
}

@end
