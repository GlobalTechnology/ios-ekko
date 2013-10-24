//
//  CourseListViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "DataManager.h"
#import "HubSyncService.h"
#import "CourseViewController.h"
#import "UIImage+Ekko.h"

#import "CourseListCell.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewType = EkkoAllCourses;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *toggleDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleDrawer setFrame:CGRectMake(0, 0, 34, 34)];
    [toggleDrawer setShowsTouchWhenHighlighted:YES];
    [toggleDrawer setImage:[UIImage imageNamed:@"show_lines.png" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [toggleDrawer addTarget:self action:@selector(toggleNavigationDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleDrawer]];
    
    [[self refreshControl] addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    switch (self.viewType) {
        case EkkoAllCourses:
            [self setFetchedResultsController:[[DataManager dataManager] fetchedResultsControllerForAllCourses]];
            [self setTitle:@"All Courses"];
            break;
        case EkkoMyCourses:
            [self setFetchedResultsController:[[DataManager dataManager] fetchedResultsControllerForMyCourses]];
            [self setTitle:@"My Courses"];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubClientSessionEstablishedNotification:) name:kEkkoHubClientSessionEstablished object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCoursesNotification:) name:EkkoHubSyncServiceCoursesSyncBegin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCoursesNotification:) name:EkkoHubSyncServiceCoursesSyncEnd object:nil];
    if ([[HubSyncService sharedService] coursesSyncInProgress]) {
        [self.refreshControl beginRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self setFetchedResultsController:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell"];
    Course *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setCourse:course];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"takeCourse"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Course *course = (Course *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        Manifest *manifest = [[DataManager dataManager] getManifestByCourseId:course.courseId withManagedObjectContext:course.managedObjectContext];
        [(CourseViewController *)[segue destinationViewController] setManifest:manifest];
    }
}

-(void)hubClientSessionEstablishedNotification:(NSNotification *)notification {
    switch (self.viewType) {
        case EkkoAllCourses:
            [self setFetchedResultsController:[[DataManager dataManager] fetchedResultsControllerForAllCourses]];
            break;
        case EkkoMyCourses:
            [self setFetchedResultsController:[[DataManager dataManager] fetchedResultsControllerForMyCourses]];
            break;
        default:
            break;
    }
}

-(void)syncCoursesNotification:(NSNotification *)notification {
    if ([EkkoHubSyncServiceCoursesSyncBegin isEqualToString:[notification name]]) {
        [self.refreshControl beginRefreshing];
    }
    else if ([EkkoHubSyncServiceCoursesSyncEnd isEqualToString:[notification name]]) {
        [self.refreshControl endRefreshing];
    }
}

-(IBAction)refresh:(UIRefreshControl *)refreshControl {
    [[HubSyncService sharedService] syncCourses];
}

- (IBAction)toggleNavigationDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
