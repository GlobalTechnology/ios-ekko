//
//  AboutCourseViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 7/29/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Ekko.h"

@interface AboutCourseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) Course *course;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *courseBanner;

+(UIViewController *)allocWithRouterParams:(NSDictionary *)params;

@end
