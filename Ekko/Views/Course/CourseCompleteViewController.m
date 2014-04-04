//
//  CourseCompleteViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseCompleteViewController.h"
#import "ProgressManager.h"
#import "Manifest+View.h"
#import "UIViewController+SwipeViewController.h"
#import "UIColor+Ekko.h"
#import "UIWebView+Ekko.h"

@interface CourseCompleteViewController ()
@property (nonatomic, weak) NSLayoutConstraint *nineBySixteenConstraint;
@end

@implementation CourseCompleteViewController

-(void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.nineBySixteenConstraint == nil) {
        self.nineBySixteenConstraint = [NSLayoutConstraint constraintWithItem:self.completeWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.completeWebView attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0];
        [self.view addConstraint:self.nineBySixteenConstraint];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationBar setDelegate:self];
    
    self.completeWebView.scrollView.bounces = NO;
    self.completeWebView.backgroundColor = [UIColor ekkoQuizBackground];
    
    NSString *completeMessage = self.course.completeMessage ?: [NSString stringWithFormat:NSLocalizedString(@"Congratulations! You finished %@.", nil), self.course.courseTitle];
    [self.completeWebView loadCourseCompleteString:completeMessage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressManagerDidUpdateProgress:) name:EkkoProgressManagerDidUpdateProgressNotification object:nil];
    [[ProgressManager progressManager] progressForCourse:self.course progress:^(Progress *progress) {
        [self.navigationBar setProgress:[progress progress]];
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EkkoProgressManagerDidUpdateProgressNotification object:nil];
}

- (IBAction)handleCourseListButton:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
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
    if (self.course && [self.course.courseId isEqualToString:[notification.userInfo objectForKey:@"courseId"]]) {
        [[ProgressManager progressManager] progressForCourse:self.course progress:^(Progress *progress) {
            [self.navigationBar setProgress:[progress progress]];
        }];
    }
}
@end
