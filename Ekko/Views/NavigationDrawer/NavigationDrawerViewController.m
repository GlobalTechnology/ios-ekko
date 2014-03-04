//
//  NavigationDrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "NavigationDrawerViewController.h"
#import "DrawerViewController.h"
#import "CourseListViewController.h"
#import "AboutEkkoViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"

@implementation NavigationDrawerViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case NavigationDrawerSectionCourses:
            return @"Courses";
        case NavigationDrawerSectionSettings:
            return @"Settings";
        default:
            return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case NavigationDrawerSectionCourses:
            return 2;
        case NavigationDrawerSectionSettings:
            return 2;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"navigationDrawerCell"];
    
    UIViewController *rootViewController = [[(UINavigationController *)[[self mm_drawerController] centerViewController] viewControllers] firstObject];
    
    BOOL highlighted = NO;
    NSString *label;
    NSString *image;
    
    switch (indexPath.section) {
        case NavigationDrawerSectionCourses:
            switch (indexPath.row) {
                case 0:
                    if ([rootViewController isKindOfClass:[CourseListViewController class]] && [(CourseListViewController *)rootViewController coursesFetchType] == EkkoAllCoursesFetchType) {
                        highlighted = YES;
                    }
                    label = @"All Courses";
                    image = @"ShowThumbnailsWithLines";
                    break;
                case 1:
                    if ([rootViewController isKindOfClass:[CourseListViewController class]] && [(CourseListViewController *)rootViewController coursesFetchType] == EkkoMyCoursesFetchType) {
                        highlighted = YES;
                    }
                    label = @"My Courses";
                    image = @"Heart";
                    break;
                default:
                    break;
            }
            break;
            
        case NavigationDrawerSectionSettings:
            switch (indexPath.row) {
                case 0:
                    if ([[TheKeyOAuth2Client sharedOAuth2Client] isAuthenticated]) {
                        label = @"Logout";
                        image = @"LogOut";
                    }
                    else {
                        label = @"Login";
                        image = @"LogIn";
                    }
                    break;
                case 1:
                    if ([rootViewController isKindOfClass:[AboutEkkoViewController class]]) {
                        highlighted = YES;
                    }
                    label = @"About Ekko";
                    image = @"Cogwheel";
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    [cell.textLabel setText:label];
    if (highlighted) {
        [cell.textLabel setTextColor:[UIColor ekkoLightBlue]];
        [cell.imageView setImage:[UIImage imageNamed:image withTint:[[UIColor ekkoLightBlue] colorWithAlphaComponent:1.f]]];
    }
    else {
        [cell.textLabel setTextColor:[UIColor darkTextColor]];
        [cell.imageView setImage:[UIImage imageNamed:image withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *rootNavigationController = (UINavigationController *)[[self mm_drawerController] centerViewController];
    switch (indexPath.section) {
        case NavigationDrawerSectionCourses: {
            switch (indexPath.row) {
                case 0: {
                    CourseListViewController *courseListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"courseListViewController"];
                    [courseListViewController setCoursesFetchType:EkkoAllCoursesFetchType];
                    [rootNavigationController setViewControllers:@[courseListViewController] animated:NO];
                    break;
                }
                case 1: {
                    CourseListViewController *courseListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"courseListViewController"];
                    [courseListViewController setCoursesFetchType:EkkoMyCoursesFetchType];
                    [rootNavigationController setViewControllers:@[courseListViewController] animated:NO];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case NavigationDrawerSectionSettings: {
            switch (indexPath.row) {
                case 0: {
                    if ([[TheKeyOAuth2Client sharedOAuth2Client] isAuthenticated]) {
                        [[TheKeyOAuth2Client sharedOAuth2Client] logout];
                    }
                    else {
                        [(DrawerViewController *)[self mm_drawerController] presentLoginDialog];
                    }
                    break;
                }
                case 1: {
                    UIViewController *aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutEkkoViewController"];
                    [rootNavigationController setViewControllers:@[aboutController] animated:NO];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    [self.navigationTableView reloadData];
    [self toggleDrawer];
}

-(void)toggleDrawer {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

@end
