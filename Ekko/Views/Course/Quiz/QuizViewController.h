//
//  QuizViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import "ContentItemProtocol.h"
#import "Quiz+Ekko.h"

@interface QuizViewController : SwipeViewController <ContentItemProtocol>

@property (nonatomic, strong) ContentItem *contentItem;
-(Quiz *)quiz;

@end
