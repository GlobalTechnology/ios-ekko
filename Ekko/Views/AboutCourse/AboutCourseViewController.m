//
//  AboutCourseViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 7/29/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "AboutCourseViewController.h"

#import "CoreDataManager.h"
#import "CourseManager.h"
#import "ConfigManager.h"

#import <Routable/Routable.h>

#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"
#import "UIImageView+Resource.h"

typedef NS_ENUM(NSInteger, CourseDetailsRow) {
    CourseDetailsRowAuthor = 0,
    CourseDetailsRowDescription = 1,
    CourseDetailsRowCopyright = 2,
};

static NSString *const kEnroll = @"Enroll";
static NSString *const kUnenroll = @"Unenroll";
static NSString *const kOpen = @"Open";

static NSInteger const kDetailsView = 1;
static NSInteger const kUnknownCourseView = 2;

@interface AboutCourseViewController ()
@property (nonatomic, weak) UISegmentedControl *actionControl;
@end

@implementation AboutCourseViewController

@synthesize course = _course;
@synthesize courseId = _courseId;

+(UIViewController *)allocWithRouterParams:(NSDictionary *)params {
    UIStoryboard *storyboard = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] storyboard];
    AboutCourseViewController *aboutCourseViewController = [storyboard instantiateViewControllerWithIdentifier:@"aboutCourseViewController"];
    [aboutCourseViewController setCourseId:[params objectForKey:@"courseId"]];
    return aboutCourseViewController;
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
        [self updateCourseView];
    }
}

-(void)setCourseId:(NSString *)courseId {
    _courseId = [courseId copy];

    Course *course = [CourseManager getCourseById:_courseId withManagedObjectContext:[[CoreDataManager sharedManager] mainQueueManagedObjectContext]];
    if (course) {
        [self setCourse:course];
    }
    else {
        [[CourseManager courseManagerForGUID:nil] syncCourse:_courseId completeBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setCourse:[CourseManager getCourseById:_courseId withManagedObjectContext:[[CoreDataManager sharedManager] mainQueueManagedObjectContext]]];
            });
        }];
    }
}

-(void)setCourse:(Course *)course {
    _course = course;
    if (self.isViewLoaded) {
        [self updateCourseView];
    }
}

-(void)navigateBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCourseView {
    UIView *detailsView = [self.view viewWithTag:kDetailsView];
    UIView *unknownView = [self.view viewWithTag:kUnknownCourseView];

    if (self.course) {
        [detailsView setHidden:false];
        [unknownView setHidden:true];

        [self.tableView reloadData];
        [self.courseTitle setText:self.course.courseTitle];

        Resource *banner = [self.course bannerResource];
        if (banner)
            [self.courseBanner setImageWithResource:banner];

        UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(activityAction:)];
        [shareButton setTintColor:[UIColor whiteColor]];
        [[self navigationItem] setRightBarButtonItem:shareButton];
    }
    else {
        [detailsView setHidden:true];
        [unknownView setHidden:false];

        [self.courseTitle setText:nil];
        [self.courseBanner setImage:nil];
        [[self navigationItem] setRightBarButtonItem:nil];
    }

}

-(IBAction)activityAction:(id)sender {
    NSURL *shareURL = [[ConfigManager sharedConfiguration].ekkolabsShareURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/course/%@", self.course.courseId]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL, [shareURL absoluteString]] applicationActivities:nil];
    [[self navigationController] presentViewController:activityViewController animated:YES completion:^{}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *value;
        switch ((CourseDetailsRow)indexPath.row) {
            case CourseDetailsRowAuthor:
                value = [self.course.authorName copy];
                break;
            case CourseDetailsRowDescription:
                value = [self.course.courseDescription copy];
                break;
            case CourseDetailsRowCopyright:
                value = [self.course.courseCopyright copy];
                break;
            default:
                value = nil;
                break;
        }
        if (value == nil || [value isEqualToString:@""]) {
            return 0.0f;
        }
        CGSize labelConstraints = CGSizeMake(tableView.frame.size.width - 30.0f, MAXFLOAT);
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];

        CGRect labelRect = [value boundingRectWithSize:labelConstraints
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f], NSFontAttributeName, nil]
                                               context:context];
        return labelRect.size.height + 30.0f;
    }
    return tableView.rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailsCell"];
    }
    switch ((CourseDetailsRow)indexPath.row) {
        case CourseDetailsRowAuthor:
            [cell.textLabel setText:@"Author"];
            [cell.detailTextLabel setText:self.course.authorName];
            break;
        case CourseDetailsRowDescription:
            [cell.textLabel setText:@"Description"];
            [cell.detailTextLabel setText:self.course.courseDescription];
            break;
        case CourseDetailsRowCopyright:
            [cell.textLabel setText:@"Copyright"];
            [cell.detailTextLabel setText:self.course.courseCopyright];
            break;
        default:
            break;
    }
    if (cell.detailTextLabel.text == nil || [cell.detailTextLabel.text isEqualToString:@""]) {
        [cell.textLabel setText:@""];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *section = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
        [section setBackgroundColor:[UIColor ekkoLightGrey]];
        [section setContentMode:UIViewContentModeCenter];

        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray array]];
        [control setMomentary:YES];
        [control setFrame:CGRectMake(20, 8, section.bounds.size.width - 40, 32)];
        [control addTarget:self action:@selector(segmentedControlClicked:) forControlEvents:UIControlEventValueChanged];
        [self setActionControl:control];
        [section addSubview:control];

        [self updateSegmentedControl];
        return section;
    }
    return nil;
}

-(void)updateSegmentedControl {
    CourseActions actions = [self.course courseActions];
    NSMutableArray *items = [NSMutableArray array];
    if (actions & CourseActionEnroll) {
        [items addObject:NSLocalizedString(kEnroll, nil)];
    }
    else if (actions & CourseActionUnenroll) {
        [items addObject:NSLocalizedString(kOpen, nil)];
        [items addObject:NSLocalizedString(kUnenroll, nil)];
    }

    [self.actionControl removeAllSegments];
    for (NSString *item in items) {
        [self.actionControl insertSegmentWithTitle:item atIndex:self.actionControl.numberOfSegments animated:NO];
    }
}

-(void)segmentedControlClicked:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    NSInteger selectedIndex = [control selectedSegmentIndex];
    if (selectedIndex == -1) return;

    NSString *selectedTitle = [control titleForSegmentAtIndex:(NSUInteger)selectedIndex];
    NSString *courseId = [self.course.courseId copy];
    if ([selectedTitle isEqualToString:NSLocalizedString(kEnroll, nil)]) {
        [[CourseManager courseManagerForGUID:nil] enrollInCourse:courseId complete:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateSegmentedControl];
                [[Routable sharedRouter] open:[NSString stringWithFormat:@"manifest/%@", courseId] animated:YES];
            });
        }];
    }
    else if ([selectedTitle isEqualToString:NSLocalizedString(kUnenroll, nil)]) {
        [[CourseManager courseManagerForGUID:nil] unenrollFromCourse:courseId complete:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateSegmentedControl];
            });
        }];
    }
    else if ([selectedTitle isEqualToString:NSLocalizedString(kOpen, nil)]) {
        [[Routable sharedRouter] open:[NSString stringWithFormat:@"manifest/%@", courseId] animated:YES];
    }
}

@end
