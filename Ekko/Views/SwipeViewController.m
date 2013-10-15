//
//  SwipeViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "SwipeViewController.h"
#import "UIViewController+SwipeViewController.h"

@interface SwipeViewController ()

@property (nonatomic, strong) UIViewController *previousViewController;
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *nextViewController;

@end

@implementation SwipeViewController

@synthesize previousViewController = _previousViewController;
@synthesize centerViewController   = _centerViewController;
@synthesize nextViewController     = _nextViewController;
@synthesize propogateSwipeOnNil    = _propogateSwipeOnNil;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft setDelegate:self];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setDelegate:self];
    [self.view addGestureRecognizer:swipeRight];
}

-(void)viewWillLayoutSubviews {
    CGRect bounds = self.view.bounds;
    if (self.centerViewController) {
        CGRect frame = self.centerViewController.view.frame;
        self.centerViewController.view.frame = CGRectMake(frame.origin.x, 0, bounds.size.width, bounds.size.height);
    }
}

-(void)handleSwipeLeft:(id)sender {
    [self swipeToNextViewController];
}

-(void)handleSwipeRight:(id)sender {
    [self swipeToPreviousViewController];
}

-(void)setCenterViewController:(UIViewController *)centerViewController {
    if (centerViewController == _centerViewController) {
        return;
    }
    if (_centerViewController) {
        //Remove Previous View Controller
        [_centerViewController willMoveToParentViewController:nil];
        [_centerViewController.view removeFromSuperview];
        [_centerViewController removeFromParentViewController];
        _previousViewController = nil;
        _nextViewController = nil;
    }
    _centerViewController = centerViewController;
    if (_centerViewController) {
        [self addChildViewController:_centerViewController];
        _centerViewController.view.frame = self.view.bounds;
        [self.view addSubview:_centerViewController.view];
        [_centerViewController didMoveToParentViewController:self];
        if (self.dataSource) {
            _previousViewController = [self.dataSource swipeViewController:self viewControllerBeforeViewController:_centerViewController];
            _nextViewController = [self.dataSource swipeViewController:self viewControllerAfterViewController:_centerViewController];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(swipeViewController:didSwipeToViewController:)]) {
            [self.delegate swipeViewController:self didSwipeToViewController:_centerViewController];
        }
    }
}

-(void)setDataSource:(id<SwipeViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.centerViewController) {
        _nextViewController     = [dataSource swipeViewController:self viewControllerAfterViewController:self.centerViewController];
        _previousViewController = [dataSource swipeViewController:self viewControllerBeforeViewController:self.centerViewController];
    }
}

-(void)setViewController:(UIViewController *)viewController direction:(SwipeViewControllerSwipeDirection)direction {
    [self setCenterViewController:viewController];
}

-(BOOL)hasNextViewController {
    if (_nextViewController) {
        return YES;
    }
    else if (self.propogateSwipeOnNil) {
        SwipeViewController *swipeViewController = [self swipeViewController];
        if (swipeViewController) {
            return [swipeViewController hasNextViewController];
        }
    }
    return NO;
}

-(BOOL)hasPreviousViewController {
    if (_previousViewController) {
        return YES;
    }
    else if (self.propogateSwipeOnNil) {
        SwipeViewController *swipeViewController = [self swipeViewController];
        if (swipeViewController) {
            return [swipeViewController hasPreviousViewController];
        }
    }
    return NO;
}

-(void)swipeToNextViewController {
    if (self.nextViewController) {
        [self addChildViewController:self.nextViewController];
        [self.centerViewController willMoveToParentViewController:nil];
        
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        
        self.nextViewController.view.frame = CGRectMake(width, 0, width, height);
        
        [self transitionFromViewController:self.centerViewController
                          toViewController:self.nextViewController
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    self.centerViewController.view.frame = CGRectMake(0 - width, 0, width, height);
                                    self.nextViewController.view.frame = CGRectMake(0, 0, width, height);
                                }
                                completion:^(BOOL finished) {
                                    [self.centerViewController removeFromParentViewController];
                                    self.previousViewController = self.centerViewController;
                                    [self.nextViewController didMoveToParentViewController:self];
                                    _centerViewController = self.nextViewController;
                                    self.nextViewController = [self.dataSource swipeViewController:self viewControllerAfterViewController:self.centerViewController];
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeViewController:didSwipeToViewController:)]) {
                                        [self.delegate swipeViewController:self didSwipeToViewController:self.centerViewController];
                                    }
                                }];
    }
    else if (self.propogateSwipeOnNil) {
        SwipeViewController *swipeViewController = [self swipeViewController];
        if (swipeViewController) {
            [swipeViewController swipeToNextViewController];
        }        
    }
}

-(void)swipeToPreviousViewController {
    if (self.previousViewController) {
        [self addChildViewController:self.previousViewController];
        [self.centerViewController willMoveToParentViewController:nil];

        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        
        self.previousViewController.view.frame = CGRectMake(0 - width, 0, width, height);
        
        [self transitionFromViewController:self.centerViewController
                          toViewController:self.previousViewController
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    self.centerViewController.view.frame = CGRectMake(width, 0, width, height);
                                    self.previousViewController.view.frame = CGRectMake(0, 0, width, height);
                                }
                                completion:^(BOOL finished) {
                                    [self.centerViewController removeFromParentViewController];
                                    self.nextViewController = self.centerViewController;
                                    [self.previousViewController didMoveToParentViewController:self];
                                    _centerViewController = self.previousViewController;
                                    self.previousViewController = [self.dataSource swipeViewController:self viewControllerBeforeViewController:self.centerViewController];
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeViewController:didSwipeToViewController:)]) {
                                        [self.delegate swipeViewController:self didSwipeToViewController:self.centerViewController];
                                    }
                                }];
    }
    else if (self.propogateSwipeOnNil) {
        SwipeViewController *swipeViewController = [self swipeViewController];
        if (swipeViewController) {
            [swipeViewController swipeToPreviousViewController];
        }
    }
}

@end
