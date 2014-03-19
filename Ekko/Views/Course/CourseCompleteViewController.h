//
//  CourseCompleteViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseNavigationBar.h"
#import "Manifest+View.h"

@interface CourseCompleteViewController : UIViewController <CourseNavigationBarDelegate>

@property (nonatomic, weak) Manifest *course;

@property (nonatomic, weak) IBOutlet CourseNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIWebView *completeWebView;

@end
