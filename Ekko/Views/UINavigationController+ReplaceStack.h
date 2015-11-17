//
//  UINavigationController+ReplaceStack.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ReplaceStack)

-(void)replaceCurrentViewControllerWith:(UIViewController *)viewController animated:(BOOL)animated;

@end
