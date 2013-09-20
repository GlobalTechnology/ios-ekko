//
//  HubQuiz.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"
#import "HubQuestionMC.h"

@interface HubQuiz : HubXMLModel

@property (nonatomic, strong) NSString *quizId;
@property (nonatomic, strong) NSString *quizTitle;

@property (nonatomic, strong, readonly) NSMutableArray *questions;

@end
