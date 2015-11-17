//
//  UINavigationController+ReplaceStack.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "UINavigationController+ReplaceStack.h"

@implementation UINavigationController (ReplaceStack)

-(void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated {
    NSMutableArray *viewStack = [NSMutableArray arrayWithArray:self.viewControllers];
    if ([viewStack count] > 0)
        [viewStack removeLastObject];
    [viewStack addObject:viewController];
    [self setViewControllers:viewStack animated:animated];
}

@end
