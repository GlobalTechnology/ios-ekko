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

-(void)setDataSource:(id<SwipeViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.centerViewController) {
        self.previousViewController = [dataSource swipeViewController:self viewControllerBeforeViewController:self.centerViewController];
        self.nextViewController     = [dataSource swipeViewController:self viewControllerAfterViewController:self.centerViewController];
    }
}

-(void)setViewController:(UIViewController *)viewController direction:(SwipeViewControllerDirection)direction {
    if (!self.centerViewController) {
        UIViewController *dummyViewController = [[UIViewController alloc] initWithCoder:nil];
        [self addChildViewController:dummyViewController];
        dummyViewController.view.frame = self.view.bounds;
        [self.view addSubview:dummyViewController.view];
        [dummyViewController didMoveToParentViewController:self];
        self.centerViewController = dummyViewController;
    }
    [self swipeToViewController:viewController swipeDirection:direction completion:^(BOOL finished) {
        self.centerViewController = viewController;
        if (self.dataSource) {
            self.previousViewController = [self.dataSource swipeViewController:self viewControllerBeforeViewController:self.centerViewController];
            self.nextViewController = [self.dataSource swipeViewController:self viewControllerAfterViewController:self.centerViewController];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(swipeViewController:didSwipeToViewController:)]) {
            [self.delegate swipeViewController:self didSwipeToViewController:self.centerViewController];
        }
    }];
}

-(UIViewController *)currentViewController {
    return self.centerViewController;
}

-(BOOL)hasNextViewController {
    if (self.previousViewController) {
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
    if (self.previousViewController) {
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


-(void)swipeToViewController:(UIViewController *)viewController swipeDirection:(SwipeViewControllerDirection)direction completion:(void (^)(BOOL finished))completion {
    [self addChildViewController:viewController];
    [self.centerViewController willMoveToParentViewController:nil];

    CGSize size = self.view.frame.size;

    void (^animations)() = ^{};
    NSTimeInterval duration = 0.0f;
    switch (direction) {
        case SwipeViewControllerDirectionNext: {
            viewController.view.frame = CGRectMake(size.width, 0, size.width, size.height);
            duration = 0.25f;
            animations = ^{
                self.centerViewController.view.frame = CGRectMake(0 - size.width, 0, size.width, size.height);
                viewController.view.frame = CGRectMake(0, 0, size.width, size.height);
            };
        }
        break;

        case SwipeViewControllerDirectionPrevious: {
            viewController.view.frame = CGRectMake(0 - size.width, 0, size.width, size.height);
            duration = 0.25f;
            animations = ^{
                self.centerViewController.view.frame = CGRectMake(size.width, 0, size.width, size.height);
                viewController.view.frame = CGRectMake(0, 0, size.width, size.height);
            };
        }
        break;

        case SwipeViewControllerDirectionNone:
        default:
            viewController.view.frame = CGRectMake(0, 0, size.width, size.height);
            break;
    }

    [self transitionFromViewController:self.centerViewController
                      toViewController:viewController
                              duration:duration
                               options:UIViewAnimationOptionTransitionNone
                            animations:animations
                            completion:^(BOOL finished) {
                                [self.centerViewController removeFromParentViewController];
                                [viewController didMoveToParentViewController:self];
                                completion(finished);
                            }];
}

-(void)swipeToNextViewController {
    if (self.nextViewController) {
        [self swipeToViewController:self.nextViewController swipeDirection:SwipeViewControllerDirectionNext completion:^(BOOL finished) {
            self.previousViewController = self.centerViewController;
            self.centerViewController = self.nextViewController;
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
        [self swipeToViewController:self.previousViewController swipeDirection:SwipeViewControllerDirectionPrevious completion:^(BOOL finished) {
            self.nextViewController = self.centerViewController;
            self.centerViewController = self.previousViewController;
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
