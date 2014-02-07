//
//  MultipleChoiceOption.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@interface MultipleChoiceOption : NSObject

@property (nonatomic, strong) NSString *optionId;
@property (nonatomic, strong) NSString *optionText;
@property (nonatomic) BOOL isAnswer;

@property (nonatomic, weak) Question *question;

@end
