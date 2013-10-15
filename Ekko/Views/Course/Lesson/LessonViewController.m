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
        [self.mediaSwipeViewController setViewController:mediaViewController direction:SwipeViewControllerSwipeDirectionNext];
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
        [self.pagesSwipeViewController setViewController:pageViewController direction:SwipeViewControllerSwipeDirectionNext];
    }
    [self.pagesSwipeViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addChildViewController:self.pagesSwipeViewController];
    [self.view addSubview:self.pagesSwipeViewController.view];
    [self.pagesSwipeViewController didMoveToParentViewController:self];
    
    /* Layout Constraints */
    NSDictionary *views = @{@"media": self.mediaSwipeViewController.view, @"nav": self.navigationBar, @"pages": self.pagesSwipeViewController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[media]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pages]|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaSwipeViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mediaSwipeViewController.view attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0.f]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[media][nav][pages]|" options:0 metrics:nil views:views]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navigationBar];
    [self.navigationBar setTitle:self.lesson.lessonTitle];
    [[ProgressManager progressManager] addProgressDelegate:self forDataSource:self.lesson];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[ProgressManager progressManager] removeProgressDelegate:self];
    [super viewDidDisappear:animated];
}

#pragma mark - ContentItemProtocol
@synthesize contentItem = _contentItem;
+(UIViewController<ContentItemProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard {
    return (UIViewController<ContentItemProtocol> *)[storyboard instantiateViewControllerWithIdentifier:@"lessonViewController"];
}

#pragma mark - CourseNavigationBarDelegate
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

#pragma mark - ProgressManagerDelegate
-(void)progressUpdateFor:(id<ProgressManagerDataSource>)dataSource currentProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dataSource isKindOfClass:[Lesson class]] && self.lesson == dataSource) {
            [self.navigationBar setProgress:progress];
        }
    });
}

@end
