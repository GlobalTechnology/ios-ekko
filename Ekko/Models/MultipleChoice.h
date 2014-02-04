//
//  MultipleChoice.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Question.h"

@interface MultipleChoice : Question

@property (nonatomic, strong) NSString *questionText;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *options;

@end
