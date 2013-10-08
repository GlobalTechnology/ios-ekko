//
//  LessonViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentItemProtocol.h"
#import "CourseNavigationBar.h"
#import "SwipeViewController.h"
#import "ProgressManager.h"

#import "Lesson+Ekko.h"

@interface LessonViewController : UIViewController <ContentItemProtocol, CourseNavigationBarDelegate, ProgressManagerDelegate>

@property (nonatomic, strong) ContentItem *contentItem;
@property (nonatomic, strong) CourseNavigationBar *navigationBar;
@property (nonatomic, strong) SwipeViewController *mediaSwipeViewController;
@property (nonatomic, strong) SwipeViewController *pagesSwipeViewController;

-(Lesson *)lesson;

@end
