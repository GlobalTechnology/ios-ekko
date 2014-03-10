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
#import "MultipleChoiceOptionCell.h"

@interface MultipleChoiceViewController : UIViewController <QuizProtocol, UITableViewDataSource, UITableViewDelegate, CourseNavigationBarDelegate, MultipleChoiceOptionCellDelegate>

@property (nonatomic, strong) MultipleChoice *question;
@property (nonatomic, strong) NSString *selectedAnswer;

@property (nonatomic, weak) IBOutlet UIWebView *questionWebView;
@property (nonatomic, weak) IBOutlet CourseNavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UITableView *optionsTableView;

@end
