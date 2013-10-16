//
//  SwipeViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeViewControllerDataSource;
@protocol SwipeViewControllerDelegate;

typedef NS_ENUM(NSUInteger, SwipeViewControllerSwipeDirection) {
    SwipeViewControllerSwipeDirectionNext,
    SwipeViewControllerSwipeDirectionPrevious,
};

@interface SwipeViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet id <SwipeViewControllerDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <SwipeViewControllerDelegate> delegate;
@property (nonatomic) BOOL propogateSwipeOnNil;

-(UIViewController *)currentViewController;
-(void)setViewController:(UIViewController *)viewController direction:(SwipeViewControllerSwipeDirection)direction;

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

@protocol SwipeViewControllerDelegate <NSObject>
@optional
-(void)swipeViewController:(SwipeViewController *)swipeViewController didSwipeToViewController:(UIViewController *)viewController;
@end