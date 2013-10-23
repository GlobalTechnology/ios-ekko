//
//  QuizCompleteViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "QuizCompleteViewController.h"
#import "QuizViewController.h"
#import "QuizManager.h"
#import "UIViewController+SwipeViewController.h"
#import "UIColor+Ekko.h"

@interface QuizCompleteViewController ()
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@end

@implementation QuizCompleteViewController

-(void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.heightConstraint == nil) {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.completeWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.completeWebView attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0];
        [self.view addConstraint:self.heightConstraint];
    }
}

-(void)setCompleteWebView:(UIWebView *)completeWebView {
    _completeWebView = completeWebView;
    _completeWebView.backgroundColor = [UIColor ekkoQuizBackground];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUInteger correct = [[QuizManager quizManager] quizResults:self.quiz];
    NSUInteger total = self.quiz.questions.count;
    
    NSString *completeHTML = @"<html><body style=\"color:#CF6D2C;font-family:helvetica;font-size:28px;text-align:center;\">%@</body></html>";
    NSString *resultsMessage = [NSString stringWithFormat:@"Results:<div style=\"font-size:34px;\">%lu/%lu</div>", (unsigned long)correct, (unsigned long)total];
    [self.completeWebView loadHTMLString:[NSString stringWithFormat:completeHTML, resultsMessage] baseURL:nil];
    
    //Quiz Complete always shows progress of 100%
    [self.navigationBar setProgress:1.f];
    [self.navigationBar setTitle:self.quiz.quizTitle];
}

- (IBAction)handleShowAnswersButton:(UIButton *)sender {
    if ([self.parentViewController isKindOfClass:[QuizViewController class]]) {
        QuizViewController *quizViewController = (QuizViewController *)self.parentViewController;
        [self.quiz setShowAnswers:YES];
        [quizViewController setViewController:[self.quiz questionViewControllerAtIndex:0 storyboard:self.storyboard] direction:SwipeViewControllerSwipeDirectionNext];
    }
}

- (IBAction)handleContinueButton:(UIButton *)sender {
    [self navigateToNext];
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

@end
