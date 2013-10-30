//
//  CourseCompleteViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseCompleteViewController.h"
#import "Manifest+Ekko.h"
#import "UIViewController+SwipeViewController.h"
#import "UIColor+Ekko.h"

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
    
    NSString *completeHTML = @"<html><body style=\"color:#CF6D2C;font-family:helvetica;font-size:28px;text-align:center;\">%@</body></html>";
    NSString *completeMessage = self.course.completeMessage ?: [NSString stringWithFormat:@"Congratulations! You finished %@.", self.course.courseTitle];
    [self.completeWebView loadHTMLString:[NSString stringWithFormat:completeHTML, completeMessage] baseURL:nil];
    
    [[ProgressManager sharedManager] addProgressDelegate:self forDataSource:self.course];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ProgressManager sharedManager] removeProgressDelegate:self];
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

#pragma mark - ProgressManagerDelegate
-(void)progressUpdateFor:(id<ProgressManagerDataSource>)dataSource currentProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationBar setProgress:progress];
    });
}

@end
