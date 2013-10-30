//
//  CourseListCell.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Ekko.h"
#import "CourseManager.h"
#import "ProgressManager.h"
#import "CourseListViewController.h"

@interface CourseListCell : UITableViewCell <UIActionSheetDelegate>

@property (weak, nonatomic) CourseListViewController *courseListViewController;
@property (weak, nonatomic) Course *course;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *courseProgress;
@property (weak, nonatomic) IBOutlet UIButton *courseActionButton;

@property (nonatomic, strong) UIActionSheet *actionSheet;

-(void)buildActionSheet;

@end
