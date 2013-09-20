//
//  SwipeViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeViewControllerDataSource;

@interface SwipeViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <SwipeViewControllerDataSource> dataSource;

@property (nonatomic) BOOL propogateSwipeOnNil;

@property (nonatomic, strong) UIViewController *viewController;

-(BOOL)hasNextViewController;
-(BOOL)hasPreviousViewController;

-(void)swipeToNextViewController;
-(void)swipeToPreviousViewController;

@end

@protocol SwipeViewControllerDataSource <NSObject>
@required
-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerBeforeViewController:(UIViewController *)viewController;
-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerAfterViewController:(UIViewController *)viewController;

@optional
-(BOOL)swipeViewController:(SwipeViewController *)swipeViewController hasViewControllerBeforeViewController:(UIViewController *)viewController;
-(BOOL)swipeViewController:(SwipeViewController *)swipeViewController hasViewControllerAfterViewController:(UIViewController *)viewController;
@end