//
//  UIViewController+SwipeViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"

@interface UIViewController (SwipeViewController)

@property (nonatomic, strong, readonly) SwipeViewController *swipeViewController;

-(void)swipeToNextViewController;
-(void)swipeToPreviousViewController;

@end
