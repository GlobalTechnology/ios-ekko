//
//  CourseListCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListCell.h"
#import <QuartzCore/QuartzCore.h>

#import "ResourceManager.h"
#import "Permission.h"
#import "CoreDataManager.h"
#import "ProgressManager.h"

#import "UIImageView+Resource.h"
#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"

#import <TheKeyOAuth2Client.h>

static const int insetViewTag = 1;

@implementation CourseListCell

-(void)setCourseActionButton:(UIButton *)courseActionButton {
    _courseActionButton = courseActionButton;
    [courseActionButton setImage:[UIImage imageNamed:@"ActionOverflow" withTint:[UIColor lightGrayColor]] forState:UIControlStateNormal];
}

-(void)prepareForReuse {
    //Reset Cell
    [self.bannerImageView setImage:nil];
    [self.courseProgress setProgress:0.f];
}

-(void)setCourse:(Course *)course {
    _course = course;

    //Set course title
    [self.courseLabel setText:course.courseTitle];
    
    //Set banner image
    Resource *banner = [course bannerResource];
    if (banner) {
        [self.bannerImageView setImageWithResource:banner];
    }

    //Set Progress
    [[ProgressManager progressManager] progressForCourseId:course.courseId progress:^(Progress *progress) {
        [self.courseProgress setProgress:[progress progress]];
    }];
}

-(void)drawRect:(CGRect)rect {
    //Draw cell drop shadow
    UIView *insetView = [self viewWithTag:insetViewTag];
    insetView.layer.masksToBounds = NO;
    insetView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    insetView.layer.shadowColor = [[UIColor blackColor] CGColor];
    insetView.layer.shadowRadius = 2.0f;
    insetView.layer.shadowOpacity = 0.5f;
    insetView.layer.shadowPath = [UIBezierPath bezierPathWithRect:insetView.bounds].CGPath;

    [super drawRect:rect];
}

-(void)buildActionSheet {
    //Build ActionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.course.courseTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    Permission *permission = self.course.permission;
    
    BOOL enroll = NO;
    BOOL unenroll = NO;
    
    if (permission.enrolled) {
        unenroll = YES;
    }
    else {
        enroll = YES;
    }
    
    switch (self.course.enrollmentType) {
        case CourseEnrollmentOpen:
            break;
        case CourseEnrollmentApproval:
        case CourseEnrollmentDisabled:
        default:
            enroll = NO;
            unenroll = NO;
            break;
    }
    
    if (enroll) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Enroll in Course", nil)];
    }
    else if (unenroll) {
        [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"Unenroll from Course", nil)]];
    }
    
    if (self.owner.coursesFetchType == EkkoAllCoursesFetchType && permission.hidden) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Show in My Courses", nil)];
    }
    else if (self.owner.coursesFetchType == EkkoMyCoursesFetchType && !permission.hidden) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Hide from My Courses", nil)];
    }
    
    [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)]];
    self.actionSheet = actionSheet;
    [self.courseActionButton setHidden:([self.actionSheet numberOfButtons] <= 1)];
}

- (IBAction)handleCourseActionButton:(id)sender {
    if ([self.actionSheet numberOfButtons] > 1) {
        [self.actionSheet showInView:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"Enroll in Course", nil)]) {
        [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] enrollInCourse:self.course.courseId complete:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.owner performSegueWithIdentifier:@"courseSegue" sender:self.course];
            });
        }];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Unenroll from Course", nil)]) {
        [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] unenrollFromCourse:self.course.courseId complete:^{}];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Hide from My Courses", nil)]) {
        [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] hideCourseFromMyCourses:self.course.courseId complete:^{}];
    }
    else if ([buttonTitle isEqualToString:NSLocalizedString(@"Show in My Courses", nil)]) {
        [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] showCourseInMyCourses:self.course.courseId complete:^{}];
    }
}

-(void)progressManagerDidUpdateProgress:(NSNotification *)notification {
    if (self.course && [self.course.courseId isEqualToString:[[notification userInfo] objectForKey:@"courseId"]]) {
        [[ProgressManager progressManager] progressForCourseId:self.course.courseId progress:^(Progress *progress) {
            [self.courseProgress setProgress:[progress progress]];
        }];
    }
}

@end
