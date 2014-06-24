//
//  LessonViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "LessonViewController.h"
#import "UIViewController+SwipeViewController.h"
#import "ProgressManager.h"

@implementation LessonViewController

-(Lesson *)lesson {
    return (Lesson *)self.contentItem;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    /* Media */
    self.mediaSwipeViewController = [[SwipeViewController alloc] init];
    [self.mediaSwipeViewController setDelegate:self];
    [self.mediaSwipeViewController setDataSource:self.lesson];
    [self.mediaSwipeViewController setPropogateSwipeOnNil:YES];
    UIViewController *mediaViewController = [self.lesson mediaViewControllerAtIndex:0 storyboard:self.storyboard];
    if (mediaViewController) {
        [self.mediaSwipeViewController setViewController:mediaViewController direction:SwipeViewControllerDirectionNone];
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
        [self.pagesSwipeViewController setViewController:pageViewController direction:SwipeViewControllerDirectionNone];
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
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.navigationBar];
    [self.navigationBar setTitle:self.lesson.title];
    [self.pageControl setNumberOfPages:self.lesson.media.count];

    [[ProgressManager progressManager] progressForLesson:self.lesson progress:^(Progress *progress) {
        [self.navigationBar setProgress:[progress progress]];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(progressManagerDidUpdateProgress:)
                                                 name:EkkoProgressManagerDidUpdateProgressNotification
                                               object:[ProgressManager progressManager]];
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EkkoProgressManagerDidUpdateProgressNotification object:nil];
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

-(void)progressManagerDidUpdateProgress:(NSNotification *)notification {
    if (self.lesson && [[self.lesson.manifest courseId] isEqualToString:[[notification userInfo] objectForKey:@"courseId"]]) {
        [[ProgressManager progressManager] progressForLesson:self.lesson progress:^(Progress *progress) {
            [self.navigationBar setProgress:[progress progress]];
        }];
    }
}

-(void)swipeViewController:(SwipeViewController *)swipeViewController didSwipeToViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MediaViewController class]]) {
        NSUInteger index = [self.lesson indexOfMediaViewController:(MediaViewController *)viewController];
        [self.pageControl setCurrentPage:index];
    }
}
@end
