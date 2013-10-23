//
//  CourseListCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListCell.h"

#import "ResourceManager.h"
#import "Permission.h"
#import "HubClient.h"

#import "UIImage+Ekko.h"
#import "UIColor+Ekko.h"

static const int insetViewTag = 1;

@implementation CourseListCell

-(void)setCourseActionButton:(UIButton *)courseActionButton {
    _courseActionButton = courseActionButton;
    [courseActionButton setImage:[UIImage imageNamed:@"ic_action_overflow.png" withTint:[UIColor lightGrayColor]] forState:UIControlStateNormal];
}

-(void)setCourse:(Course *)course {
    _course = course;
    
    //Reset Cell
    [self.bannerImageView setImage:nil];
    [self.courseProgress setProgress:0.f];

    //Set course title
    [self.courseLabel setText:course.courseTitle];
    
    //Set banner image
    Resource *banner = (Resource *)[course banner];
    if (banner) {
        [[ResourceManager resourceManager] getImageResource:banner completeBlock:^(Resource *resource, UIImage *image) {
            if (image && [resource.resourceId isEqualToString:banner.resourceId]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bannerImageView setImage:image];
                });
            }
        }];
    }
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //Draw cell drop shadow
    UIView *insetView = [self viewWithTag:1];
    insetView.layer.masksToBounds = NO;
    insetView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    insetView.layer.shadowColor = [[UIColor blackColor] CGColor];
    insetView.layer.shadowRadius = 2.0f;
    insetView.layer.shadowOpacity = 0.5f;
    insetView.layer.shadowPath = [UIBezierPath bezierPathWithRect:insetView.bounds].CGPath;
}

- (IBAction)handleCourseActionButton:(id)sender {
    //Build ActionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
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
        case CourseEnrollmentApproval:
            break;
        case CourseEnrollmentDisabled:
        default:
            enroll = NO;
            unenroll = NO;
            break;
    }
    
    if (enroll) {
        [actionSheet addButtonWithTitle:@"Enroll in Course"];
    }
    else if (unenroll) {
        [actionSheet setDestructiveButtonIndex:[actionSheet addButtonWithTitle:@"Unenroll from Course"]];
    }
    
    [actionSheet setCancelButtonIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
    [actionSheet showInView:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Enroll in Course"]) {
        [[HubClient hubClient] enrollInCourse:self.course.courseId callback:^(HubCourse *course) {
            NSLog(@"Enrolled in Course: %@", [course.courseMeta courseTitle]);
        }];
    }
    else if ([buttonTitle isEqualToString:@"Unenroll from Course"]) {
        [[HubClient hubClient] unenrollFromCourse:self.course.courseId callback:^(BOOL success) {
            NSLog(@"Unenrolled from Course: %@", success ? @"YES" : @"NO");
        }];
    }
}

@end
