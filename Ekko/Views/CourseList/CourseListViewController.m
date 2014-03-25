//
//  CourseListViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListViewController.h"

#import "ManifestManager.h"
#import "CoreDataManager.h"
#import "EkkoCloudClient.h"

#import "CourseViewController.h"
#import "CourseListCell.h"

#import "Permission.h"
#import "UIImage+Ekko.h"

#import <UIViewController+MMDrawerController.h>
#import <TheKeyOAuth2Client.h>

@interface CourseListViewController ()

@end

@implementation CourseListViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //Default to My Courses view
        self.coursesFetchType = EkkoMyCoursesFetchType;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    // Add hamburger button to NavigationBar
    UIButton *toggleDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleDrawer setFrame:CGRectMake(0, 0, 34, 34)];
    [toggleDrawer setShowsTouchWhenHighlighted:YES];
    [toggleDrawer setImage:[UIImage imageNamed:@"ShowLines" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [toggleDrawer addTarget:self action:@selector(toggleNavigationDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleDrawer]];

    // Add refresh control to TableViewController
    [[self refreshControl] addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setFetchedResultsController:[[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] fetchedResultsControllerForType:self.coursesFetchType]];
    switch (self.coursesFetchType) {
        case EkkoMyCoursesFetchType:
            [self setTitle:@"My Courses"];
            break;
        case EkkoAllCoursesFetchType:
        default:
            [self setTitle:@"All Courses"];
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theKeyDidChangeGUID:) name:TheKeyOAuth2ClientDidChangeGuidNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseManagerWillSyncCourses:) name:EkkoCourseManagerWillSyncCoursesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseManagerDidSyncCourses:) name:EkkoCourseManagerDidSyncCoursesNotification object:nil];
    
    if ([[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] isSyncInProgress]) {
        [self.refreshControl beginRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self setFetchedResultsController:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"courseSegue"]) {
        Course *course = nil;
        if ([sender isKindOfClass:[Course class]]) {
            course = (Course *)sender;
        }
        else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            course = (Course *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        }
        [[ManifestManager manifestManager] getManifest:course.courseId withOptions:0 completeBlock:^(Manifest *manifest) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [(CourseViewController *)[segue destinationViewController] setManifest:manifest];
            });
        }];
    }
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell"];
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setCourseListViewController:self];
    [cell setCourse:course];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(CourseListCell *)cell buildActionSheet];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = (Course *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    if ([course.permission pending]) {
        //Course is awaiting Instructor Approval
        [[[UIAlertView alloc] initWithTitle:course.courseTitle message:@"Pending Instructor Approval." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (![course.permission contentVisible]) {
        //Must enroll in Course
        [[[UIAlertView alloc] initWithTitle:course.courseTitle message:course.courseDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enroll", nil] show];
    }
/*
    else if (![[ManifestManager sharedManager] hasManifestWithCourseId:course.courseId]) {
        [[ManifestManager sharedManager] syncManifest:course.courseId complete:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"courseSegue" sender:course];
            });
        }];
    }
 */
    else {
        [self performSegueWithIdentifier:@"courseSegue" sender:course];
    }
}

-(void)theKeyDidChangeGUID:(NSNotification *)notification {
    NSString *guid = notification.userInfo[@"guid"];
    [self setFetchedResultsController:[[CourseManager courseManagerForGUID:guid] fetchedResultsControllerForType:self.coursesFetchType]];
}

-(void)courseManagerWillSyncCourses:(NSNotification *)notification {
    [self.refreshControl beginRefreshing];
}

-(void)courseManagerDidSyncCourses:(NSNotification *)notification {
    [self.refreshControl endRefreshing];
}

-(IBAction)refresh:(UIRefreshControl *)refreshControl {
    [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] syncCourses];
}

- (IBAction)toggleNavigationDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        return;
    }
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Enroll"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Course *course = (Course *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] enrollInCourse:course.courseId complete:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"courseSegue" sender:course];
            });
        }];
    }
}

@end
