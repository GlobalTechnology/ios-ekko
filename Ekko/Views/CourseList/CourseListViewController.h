//
//  CourseListViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CoreDataTableViewController.h"

typedef NS_ENUM(NSUInteger, EkkoCourseListViewType) {
    EkkoAllCourses,
    EkkoMyCourses,
};

@interface CourseListViewController : CoreDataTableViewController

@property (nonatomic) EkkoCourseListViewType courseListType;

@end
