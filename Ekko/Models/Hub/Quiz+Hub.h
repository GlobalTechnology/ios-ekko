//
//  Quiz+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Quiz.h"
#import "HubQuiz.h"

@interface Quiz (Hub)

-(void)updateWithHubQuiz:(HubQuiz *)hubQuiz;

@end
