//
//  NavigationDrawerViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationDrawerSection) {
    NavigationDrawerSectionCourses = 0,
    NavigationDrawerSectionSettings = 1,
};

@interface NavigationDrawerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
