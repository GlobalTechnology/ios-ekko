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

#import "UIColor+Ekko.h"

@implementation MultipleChoiceViewController
@synthesize question = _question;

+(UIViewController<QuizProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard {
    return (UIViewController<QuizProtocol> *)[storyboard instantiateViewControllerWithIdentifier:@"multipleChoiceViewController"];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180.f)];
    self.questionWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.questionWebView];
    
    self.navigationBar = [[CourseNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45.f)];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    NSDictionary *views = @{@"web":self.questionWebView, @"nav":self.navigationBar, @"table":self.optionsTable};
    [self.optionsTable removeConstraint:self.tableHeightConstraint];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[web]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nav]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[web][nav(==45)][table]" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.questionWebView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.questionWebView attribute:NSLayoutAttributeWidth multiplier:9.f/16.f constant:0]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.questionWebView loadHTMLString:self.question.questionText baseURL:nil];
    [self.questionWebView setOpaque:NO];
    [self.questionWebView.scrollView setBounces:NO];
    [self.questionWebView setBackgroundColor:[UIColor ekkoLightGrey]];
    
    [self.navigationBar setTitle:self.title];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question.options count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultipleChoiceOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"multipleChoiceOptionCell"];
    
    MultipleChoiceOption *option = [self.question.options objectAtIndex:indexPath.row];
    [cell.checkbox setTitle:option.optionText];
    
    return cell;
}

-(void)navigateToNext {
    [self swipeToNextViewController];
}

-(void)navigateToPrevious {
    [self swipeToPreviousViewController];
}

@end
