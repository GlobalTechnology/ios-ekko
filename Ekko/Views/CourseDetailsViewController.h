//
//  CourseDetailsViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 7/2/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+Ekko.h"

@interface CourseDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) Course *course;

@property (weak, nonatomic) IBOutlet UIImageView *courseBanner;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *courseDescription;


+ (id)allocWithRouterParams:(NSDictionary *)params;

@end
