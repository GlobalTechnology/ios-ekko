//
//  LessonViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "LessonViewController.h"
#import "UIViewController+SwipeViewController.h"

@implementation LessonViewController
@synthesize contentItem = _contentItem;

+(UIViewController<ContentItemProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard {
    return (UIViewController<ContentItemProtocol> *)[storyboard instantiateViewControllerWithIdentifier:@"lessonViewController"];
}

-(Lesson *)lesson {
    return (Lesson *)self.contentItem;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    /* Media */
    self.mediaSwipeViewController = [[SwipeViewController alloc] init];
    [self.mediaSwipeViewController setDataSource:self.lesson];
    [self.mediaSwipeViewController setPropogateSwipeOnNil:YES];
    UIViewController *mediaViewController = [self.lesson mediaViewControllerAtIndex:0 storyboard:self.storyboard];
    if (mediaViewController) {
        [self.mediaSwipeViewController setViewController:mediaViewController];
    }
    [self.mediaSwipeViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.mediaSwipeViewController];
    [self.view addSubview:self.mediaSwipeViewController.view];
    [self.mediaSwipeViewController didMoveToParentViewController:self];
    
    
    /* Pages */
    self.pagesSwipeViewController = [[SwipeViewController alloc] init];
    [self.pagesSwipeViewController setDataSource:self.lesson];
    [self.pagesSwipeViewController setPropogateSwipeOnNil:YES];
    UIViewController *pageViewController = [self.lesson pageViewControllerAtIndex:0 storyboard:self.storyboard];
    if (pageViewController) {
        [self.pagesSwipeViewController setViewController:pageViewController];
    }
    [self.pagesSwipeViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.pagesSwipeViewController];
    [self.view addSubview:self.pagesSwipeViewController.view];
    [self.pagesSwipeViewController didMoveToParentViewController:self];
    
    
    /* Navigation Bar */
    self.navigationBar = [[CourseNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45.f)];
    [self.navigationBar setDelegate:self];
    [self.navigationBar setTitle:self.lesson.lessonTitle];
    [self.view addSubview:self.navigationBar];
    
    
    /* Layout Constraints */
    NSDictionary *views = @{@"media": self.mediaSwipeViewController.view, @"nav": self.navigationBar, @"pages": self.pagesSwipeViewController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[media]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nav]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pages]|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaSwipeViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mediaSwipeViewController.view attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[media][nav(==45)][pages]|" options:0 metrics:nil views:views]];
}

-(void)navigateToPrevious {
    SwipeViewController *swipeViewController = self.swipeViewController;
    if (swipeViewController) {
        [swipeViewController swipeToPreviousViewController];
    }
}

-(void)navigateToNext {
    SwipeViewController *swipeViewController = self.swipeViewController;
    if (swipeViewController) {
        [swipeViewController swipeToNextViewController];
    }
}

@end
