//
//  CourseViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "CourseDrawerViewController.h"
#import "UIImage+Ekko.h"

@implementation CourseViewController

@synthesize manifest    = _manifest;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
    
    //Remove NavigationController default back button
    [self.navigationItem setLeftItemsSupplementBackButton:NO];
    
    //Create custom Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"LeftArrow" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];    
    
    //Create course drawer toggle button (right side drawer)
    UIButton *toggleCourseDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleCourseDrawer setFrame:CGRectMake(0, 0, 34, 34)];
    [toggleCourseDrawer setShowsTouchWhenHighlighted:YES];
    [toggleCourseDrawer setImage:[UIImage imageNamed:@"ShowLines" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [toggleCourseDrawer addTarget:self action:@selector(toggleCourseDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleCourseDrawer]];
}

-(void)setManifest:(Manifest *)manifest {
    _manifest = manifest;
    UIViewController *viewController = [self.manifest viewControllerAtIndex:0 storyboard:self.storyboard];
    if (viewController) {
        [self setViewController:viewController direction:SwipeViewControllerSwipeDirectionNext];
        [self setDataSource:manifest];
    }
    [self.navigationItem setTitle:[self.manifest courseTitle]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CourseDrawerViewController *courseDrawer = [[self storyboard] instantiateViewControllerWithIdentifier:@"courseDrawerViewController"];
    [courseDrawer setCourseViewController:self];
    if ([self.currentViewController conformsToProtocol:@protocol(ContentItemProtocol) ]) {
        [courseDrawer setItem:[(UIViewController<ContentItemProtocol> *)self.currentViewController contentItem]];
    }
    [[self mm_drawerController] setRightDrawerViewController:courseDrawer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[self mm_drawerController] setRightDrawerViewController:nil];
    [super viewWillDisappear:animated];
}

-(void)toggleCourseDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)swipeViewController:(SwipeViewController *)swipeViewController didSwipeToViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ContentItemProtocol)]) {
        UIViewController *rightViewController = [[self mm_drawerController] rightDrawerViewController];
        if ([rightViewController isKindOfClass:[CourseDrawerViewController class]]) {
            [(CourseDrawerViewController *)rightViewController setItem:[(UIViewController<ContentItemProtocol> *)viewController contentItem]];
        }
    }
}

@end
