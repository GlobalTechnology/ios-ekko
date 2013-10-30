//
//  NavigationDrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "NavigationDrawerViewController.h"
#import "CourseListViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"
#import <TheKey/TheKey.h>
#import "AppDelegate.h"

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
    
    switch (indexPath.section) {
        case NavigationDrawerSectionCourses:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"All Courses"];
                    [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_071_book.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                case 1:
                    [cell.textLabel setText:@"My Courses"];
                    [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_012_heart.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                default:
                    break;
            }
            break;
            
        case NavigationDrawerSectionSettings:
            switch (indexPath.row) {
                case 0:
                    if ([[TheKey theKey] canAuthenticate]) {
                        [cell.textLabel setText:@"Logout"];
                        [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_387_log_out.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    }
                    else {
                        [cell.textLabel setText:@"Login"];
                        [cell.imageView setImage:[UIImage imageNamed:@"glyphicons_386_log_in.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    }
                    break;
                case 1:
                    [cell.textLabel setText:@"About Ekko"];
                    [cell.imageView setImage:[UIImage imageNamed:@"cogwheel.png" withTint:[[UIColor darkTextColor] colorWithAlphaComponent:0.5f]]];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
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
                    [[TheKey theKey] signOut];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showLoginDialog];
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
    [self toggleDrawer];
}

-(void)toggleDrawer {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {}];
}

@end
