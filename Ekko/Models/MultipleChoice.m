//
//  MultipleChoice.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "MultipleChoice.h"

@implementation MultipleChoice

@synthesize options = _options;

-(EkkoQuestionType)questionType {
    return EkkoQuestionTypeMultipleChoice;
}

-(NSMutableOrderedSet *)options {
    if (!_options) {
        _options = [NSMutableOrderedSet orderedSet];
    }
    return _options;
}

@end
