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
#import "UIColor+Ekko.h"
#import "UIImageView+Resource.h"

#import "CourseManager.h"
#import "CoreDataManager.h"

@implementation CourseDetailsViewController

@synthesize courseId = _courseId;

+(id)allocWithRouterParams:(NSDictionary *)params {
    UIStoryboard *storyboard = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] storyboard];
    CourseDetailsViewController *courseDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"courseDetailsViewController"];
    [courseDetailsViewController setCourseId:[params objectForKey:@"courseId"]];
    return courseDetailsViewController;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    //Create custom Back Button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setShowsTouchWhenHighlighted:YES];
    [backButton setImage:[UIImage imageNamed:@"LeftArrow" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton]];

    if (self.course) {
        [self renderCourse];
    }

//    UIButton *toggleDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
//    [toggleDrawer setFrame:CGRectMake(0, 0, 34, 34)];
//    [toggleDrawer setShowsTouchWhenHighlighted:YES];
//    [toggleDrawer setImage:[UIImage imageNamed:@"ShowLines" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [toggleDrawer addTarget:self action:@selector(toggleNavigationDrawer:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleDrawer]];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
         cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descriptionCell"];
        }
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return cell;
}

-(void)setCourseId:(NSString *)courseId {
    _courseId = [courseId copy];

    Course *course = [CourseManager getCourseById:_courseId withManagedObjectContext:[[CoreDataManager sharedManager] mainQueueManagedObjectContext]];
    [self setCourse:course];
}

-(void)setCourse:(Course *)course {
    _course = course;
    if (self.isViewLoaded) {
        [self renderCourse];
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
//    [view addSubview:[[UISegmentedControl alloc] initWithItems:@[@"Button", @"Enroll"]]];
//    return view;
//}

-(void)renderCourse {
    //Set course title
    [self.courseTitle setText:self.course.courseTitle];

    //Set banner image
    Resource *banner = [self.course bannerResource];
    if (banner) {
        [self.courseBanner setImageWithResource:banner];
    }
}

- (IBAction)toggleNavigationDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
