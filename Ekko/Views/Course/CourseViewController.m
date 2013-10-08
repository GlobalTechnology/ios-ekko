//
//  CourseViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UIImage+Ekko.h"

@implementation CourseViewController
@synthesize manifest = _manifest;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Remove NavigationController default back button
    [self.navigationItem setLeftItemsSupplementBackButton:NO];
    
    //Create custom Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"left_arrow.png" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];    
    
    //Create course drawer toggle button (right side drawer)
    UIButton *toggleCourseDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleCourseDrawer setFrame:CGRectMake(0, 0, 34, 34)];
    [toggleCourseDrawer setShowsTouchWhenHighlighted:YES];
    [toggleCourseDrawer setImage:[UIImage imageNamed:@"show_lines.png" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [toggleCourseDrawer addTarget:self action:@selector(toggleCourseDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleCourseDrawer]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.manifest) {
        UIViewController *viewController = [self.manifest viewControllerAtIndex:0 storyboard:self.storyboard];
        if (viewController) {
            [self setViewController:viewController];
            [self setDataSource:self.manifest];
        }
        
        [self.navigationItem setTitle:[self.manifest courseTitle]];
    }
    
    [[self mm_drawerController] setRightDrawerViewController:[[self storyboard] instantiateViewControllerWithIdentifier:@"courseDrawer"]];
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

@end
