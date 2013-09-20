//
//  HubQuestionMC.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubQuestion.h"
#import "HubOption.h"

@interface HubQuestionMC : HubQuestion

@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong, readonly) NSMutableArray *options;

@end
