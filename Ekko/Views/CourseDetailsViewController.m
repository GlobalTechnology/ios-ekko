//
//  CourseDetailsViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 7/2/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UIImage+Ekko.h"

@implementation CourseDetailsViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    //Create custom Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"LeftArrow" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];

//    UIButton *toggleDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
//    [toggleDrawer setFrame:CGRectMake(0, 0, 34, 34)];
//    [toggleDrawer setShowsTouchWhenHighlighted:YES];
//    [toggleDrawer setImage:[UIImage imageNamed:@"ShowLines" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [toggleDrawer addTarget:self action:@selector(toggleNavigationDrawer:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleDrawer]];
}

- (IBAction)toggleNavigationDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
