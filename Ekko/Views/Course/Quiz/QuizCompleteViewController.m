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
#import "UIWebView+Ekko.h"

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
    
    [self.completeWebView loadQuizResultsString:NSLocalizedString(@"Results", nil) total:self.quiz.questions.count correct:[[QuizManager quizManager] quizResults:self.quiz]];
    
    //Quiz Complete always shows progress of 100%
    [self.navigationBar setProgress:1.f];
    [self.navigationBar setTitle:self.quiz.title];
}

- (IBAction)handleShowAnswersButton:(UIButton *)sender {
    if ([self.parentViewController isKindOfClass:[QuizViewController class]]) {
        QuizViewController *quizViewController = (QuizViewController *)self.parentViewController;
        [self.quiz setShowAnswers:YES];
        [quizViewController setViewController:[self.quiz questionViewControllerAtIndex:0 storyboard:self.storyboard] direction:SwipeViewControllerDirectionNone];
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
