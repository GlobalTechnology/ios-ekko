//
//  Quiz.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ContentItem.h"

@interface Quiz : ContentItem

@property (nonatomic, strong) NSString *quizId;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *questions;

@end
