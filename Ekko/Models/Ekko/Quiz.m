//
//  Quiz.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Quiz.h"

@implementation Quiz

@synthesize questions = _questions;

-(NSString *)quizId {
    return self.contentId;
}

-(void)setQuizId:(NSString *)quizId {
    self.contentId = quizId;
}

-(EkkoContentType)contentType {
    return EkkoContentTypeQuiz;
}

-(NSMutableOrderedSet *)questions {
    if (!_questions) {
        _questions = [NSMutableOrderedSet orderedSet];
    }
    return _questions;
}

@end
