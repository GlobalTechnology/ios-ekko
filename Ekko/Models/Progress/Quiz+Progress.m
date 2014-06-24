//
//  Quiz+Progress.m
//  Ekko
//
//  Created by Brian Zoetewey on 3/26/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Quiz+Progress.h"
#import "Question.h"
#import "MultipleChoice.h"

@implementation Quiz (Progress)

-(NSMutableSet *)progressItems {
    NSMutableSet *set = [NSMutableSet set];
    for (Question *question in self.questions) {
        if ([question isKindOfClass:[MultipleChoice class]]) {
            [set addObject:[[(MultipleChoice *)question answer].optionId copy]];
        }
    }
    return set;
}

@end
