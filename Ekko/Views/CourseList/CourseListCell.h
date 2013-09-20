//
//  CourseListCell.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Course+Ekko.h"
#import "ResourceService.h"

@interface CourseListCell : UITableViewCell <ResourceServiceImageDelegate>

@property (weak, nonatomic) Course *course;
@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;

@end
