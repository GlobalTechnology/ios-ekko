//
//  MultipleChoiceViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/6/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizProtocol.h"
#import "CourseNavigationBar.h"
#import "MultipleChoice.h"

@interface MultipleChoiceViewController : UIViewController <QuizProtocol, UITableViewDataSource, UITableViewDelegate, CourseNavigationBarDelegate>

@property (nonatomic, strong) MultipleChoice *question;

@property (nonatomic, strong) UIWebView *questionWebView;
@property (nonatomic, strong) CourseNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *optionsTable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@end
