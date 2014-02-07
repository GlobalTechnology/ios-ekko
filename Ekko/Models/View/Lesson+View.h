//
//  Lesson+View.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Lesson.h"
#import "SwipeViewController.h"
#import "PageViewController.h"
#import "MediaViewController.h"

@interface Lesson (View) <SwipeViewControllerDataSource>
-(UIViewController *)viewControllerBeforePageViewController:(PageViewController *)pageViewController;
-(UIViewController *)viewControllerAfterPageViewController:(PageViewController *)pageViewController;
-(PageViewController *)pageViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
-(NSUInteger)indexOfPageViewController:(PageViewController *)pageViewController;

-(UIViewController *)viewControllerBeforeMediaViewController:(MediaViewController *)mediaViewController;
-(UIViewController *)viewControllerAfterMediaViewController:(MediaViewController *)mediaViewController;
-(MediaViewController *)mediaViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
-(NSUInteger)indexOfMediaViewController:(MediaViewController *)mediaViewController;
@end
