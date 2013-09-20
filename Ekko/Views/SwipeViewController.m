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
@property (nonatomic, strong) UIViewController *nextViewController;

@end

@implementation SwipeViewController

@synthesize previousViewController = _previousViewController;
@synthesize viewController         = _viewController;
@synthesize nextViewController     = _nextViewController;
@synthesize propogateSwipeOnNil   = _propogateSwipeOnNil;

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
    if (self.viewController) {
        CGRect frame = self.viewController.view.frame;
        self.viewController.view.frame = CGRectMake(frame.origin.x, 0, bounds.size.width, bounds.size.height);
    }
}

-(void)handleSwipeLeft:(id)sender {
    [self swipeToNextViewController];
}

-(void)handleSwipeRight:(id)sender {
    [self swipeToPreviousViewController];
}

-(void)setViewController:(UIViewController *)viewController {
    if (viewController == _viewController) {
        return;
    }
    if (_viewController) {
        //Remove Previous View Controller
        [_viewController willMoveToParentViewController:nil];
        [_viewController.view removeFromSuperview];
        [_viewController removeFromParentViewController];
        _previousViewController = nil;
        _nextViewController = nil;
    }
    _viewController = viewController;
    if (_viewController) {
        [self addChildViewController:_viewController];
        _viewController.view.frame = self.view.bounds;
        [self.view addSubview:_viewController.view];
        [_viewController didMoveToParentViewController:self];
        if (self.dataSource) {
            _previousViewController = [self.dataSource swipeViewController:self viewControllerBeforeViewController:_viewController];
            _nextViewController = [self.dataSource swipeViewController:self viewControllerAfterViewController:_viewController];
        }
    }
}

-(void)setDataSource:(id<SwipeViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.viewController) {
        _nextViewController     = [dataSource swipeViewController:self viewControllerAfterViewController:self.viewController];
        _previousViewController = [dataSource swipeViewController:self viewControllerBeforeViewController:self.viewController];
    }
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
        [self.viewController willMoveToParentViewController:nil];
        
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        
        self.nextViewController.view.frame = CGRectMake(width, 0, width, height);
        
        [self transitionFromViewController:self.viewController
                          toViewController:self.nextViewController
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    self.viewController.view.frame = CGRectMake(0 - width, 0, width, height);
                                    self.nextViewController.view.frame = CGRectMake(0, 0, width, height);
                                }
                                completion:^(BOOL finished) {
                                    [self.viewController removeFromParentViewController];
                                    self.previousViewController = self.viewController;
                                    [self.nextViewController didMoveToParentViewController:self];
                                    _viewController = self.nextViewController;
                                    self.nextViewController = [self.dataSource swipeViewController:self viewControllerAfterViewController:self.viewController];
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
        [self.viewController willMoveToParentViewController:nil];

        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        
        self.previousViewController.view.frame = CGRectMake(0 - width, 0, width, height);
        
        [self transitionFromViewController:self.viewController
                          toViewController:self.previousViewController
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    self.viewController.view.frame = CGRectMake(width, 0, width, height);
                                    self.previousViewController.view.frame = CGRectMake(0, 0, width, height);
                                }
                                completion:^(BOOL finished) {
                                    [self.viewController removeFromParentViewController];
                                    self.nextViewController = self.viewController;
                                    [self.previousViewController didMoveToParentViewController:self];
                                    _viewController = self.previousViewController;
                                    self.previousViewController = [self.dataSource swipeViewController:self viewControllerBeforeViewController:self.viewController];
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
