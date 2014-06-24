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

#import "Lesson+View.h"

@interface LessonViewController : UIViewController <ContentItemProtocol, CourseNavigationBarDelegate, SwipeViewControllerDelegate>

@property (nonatomic, strong) ContentItem *contentItem;
@property (nonatomic, weak) IBOutlet CourseNavigationBar *navigationBar;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) SwipeViewController *mediaSwipeViewController;
@property (nonatomic, strong) SwipeViewController *pagesSwipeViewController;

-(Lesson *)lesson;

@end
