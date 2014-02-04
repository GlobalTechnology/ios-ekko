//
//  Question+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Question+Ekko.h"
#import "Quiz.h"
#import "Manifest.h"

@implementation Question (Ekko)

-(NSString *)courseId {
    return self.quiz.manifest.courseId;
}

@end
