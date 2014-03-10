//
//  MultipleChoiceViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/6/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MultipleChoiceViewController.h"
#import "MultipleChoice.h"
#import "MultipleChoiceOption.h"
#import "MultipleChoiceOptionCell.h"
#import "UIViewController+SwipeViewController.h"
#import "Quiz+View.h"
#import "UIColor+Ekko.h"
#import "UIWebView+Ekko.h"
#import "QuizManager.h"

@interface MultipleChoiceViewController ()
@property (nonatomic, strong) NSLayoutConstraint *questionWebViewHeightConstraint;
@end

@implementation MultipleChoiceViewController
@synthesize question = _question;

+(UIViewController<QuizProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard {
    return (UIViewController<QuizProtocol> *)[storyboard instantiateViewControllerWithIdentifier:@"multipleChoiceViewController"];
}

-(void)setQuestionWebView:(UIWebView *)questionWebView {
    _questionWebView = questionWebView;
    [questionWebView.scrollView setBounces:NO];
    [questionWebView setBackgroundColor:[UIColor ekkoQuizBackground]];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    if (self.questionWebViewHeightConstraint == nil) {
        self.questionWebViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.questionWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.questionWebView attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0];
        [self.view addConstraint:self.questionWebViewHeightConstraint];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.selectedAnswer = [[QuizManager sharedManager] selectedMultipleChoiceAnswer:self.question];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.questionWebView loadQuizQuestionString:self.question.questionText];
    
    [self.navigationBar setTitle:self.question.quiz.title];
    NSUInteger questionIndex = [self.question.quiz.questions indexOfObject:self.question];
    if (questionIndex != NSNotFound) {
        [self.navigationBar setProgress:(float)questionIndex/(float)self.question.quiz.questions.count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question.options count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultipleChoiceOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multipleChoiceOptionCell"];
    [cell setDelegate:self];

    MultipleChoiceOption *option = [self.question.options objectAtIndex:indexPath.row];

    [cell.checkbox setTitle:option.optionText];
    if (self.question.quiz.showAnswers && option.isAnswer) {
        cell.backgroundColor = [UIColor ekkoAnswerGreen];
    }
    else {
        cell.backgroundColor = nil;
    }
    
    if (self.selectedAnswer && [self.selectedAnswer isEqualToString:option.optionId]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [cell.checkbox setCheckState:M13CheckboxStateChecked];
    }

    return cell;
}

-(void)multipleChoiceOptionCell:(MultipleChoiceOptionCell *)cell didChangeSelected:(BOOL)selected {
    NSIndexPath *indexPath = [self.optionsTableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    NSIndexPath *selectedPath = [self.optionsTableView indexPathForSelectedRow];
    MultipleChoiceOption *option = [self.question.options objectAtIndex:indexPath.row];

    if (selected) {
        if (selectedPath && selectedPath.row == indexPath.row) {
            return;
        }

        // Set new selected option
        [self.optionsTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [[QuizManager sharedManager] saveMultipleChoiceAnswer:option];

        // Deselect old selected option
        if (selectedPath) {
            MultipleChoiceOptionCell *oldCell = (MultipleChoiceOptionCell *)[self.optionsTableView cellForRowAtIndexPath:selectedPath];
            [oldCell.checkbox setCheckState:M13CheckboxStateUnchecked];
        }
    }
    else  {
        if (selectedPath && selectedPath.row == indexPath.row) {
            // Do not allow deselecting the currently selected option
            [cell.checkbox setCheckState:M13CheckboxStateChecked];
        }
    }
}

-(void)navigateToNext {
    [self swipeToNextViewController];
}

-(void)navigateToPrevious {
    [self swipeToPreviousViewController];
}

@end
