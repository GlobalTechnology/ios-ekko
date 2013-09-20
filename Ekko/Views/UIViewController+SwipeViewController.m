//
//  UIViewController+SwipeViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "UIViewController+SwipeViewController.h"

@implementation UIViewController (SwipeViewController)

-(SwipeViewController *)swipeViewController {
    UIViewController *parent = self;
    do {
        parent = parent.parentViewController;
        if ([parent isKindOfClass:[SwipeViewController class]]) {
            return (SwipeViewController *)parent;
        }
    } while (parent);
    return nil;
}

-(void)swipeToNextViewController {
    SwipeViewController *swipeViewController = [self swipeViewController];
    if (swipeViewController) {
        [swipeViewController swipeToNextViewController];
    }
}

-(void)swipeToPreviousViewController {
    SwipeViewController *swipeViewController = [self swipeViewController];
    if (swipeViewController) {
        [swipeViewController swipeToPreviousViewController];
    }
}

@end
