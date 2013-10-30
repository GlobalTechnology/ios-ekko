//
//  CourseListViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CoreDataTableViewController.h"

#import "CourseManager.h"

@interface CourseListViewController : CoreDataTableViewController <UIAlertViewDelegate>

@property (nonatomic) EkkoCoursesFetchType coursesFetchType;

@end
