//
//  QuizCompleteViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseNavigationBar.h"
#import "Quiz+View.h"

@interface QuizCompleteViewController : UIViewController <CourseNavigationBarDelegate>

@property (nonatomic, weak) Quiz *quiz;

@property (nonatomic, weak) IBOutlet UIWebView *completeWebView;
@property (nonatomic, weak) IBOutlet CourseNavigationBar *navigationBar;

@end
