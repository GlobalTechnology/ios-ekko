//
//  CourseListCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListCell.h"

#import "ResourceManager.h"
#import "Manifest+Ekko.h"

static const int insetViewTag = 1;

@implementation CourseListCell

-(void)setCourse:(Course *)course {
    _course = course;
    
    //Reset Cell
    [self.bannerImageView setImage:nil];
    [self.courseProgress setProgress:0.f];
//    [[ProgressManager progressManager] removeProgressDelegate:self];

    //Set course title
    [self.courseLabel setText:course.courseTitle];
    
    //Set banner image
    Resource *banner = [course bannerResource];
    if (banner) {
        [[ResourceManager resourceManager] getImageResource:banner completeBlock:^(UIImage *image) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.bannerImageView setImage:image];
                });
            }
        }];
    }
/*
    //Set progress
    id<ProgressManagerDataSource> progressDataSource = [[CoreDataService sharedService] getManifestObjectByCourseId:[course courseId]];
    if (progressDataSource) {
        [[ProgressManager progressManager] addProgressDelegate:self forDataSource:progressDataSource];
    }
*/
}

-(void)progressUpdateFor:(id<ProgressManagerDataSource>)dataSource currentProgress:(float)progress {
    if (self.course && [self.course.courseId isEqualToString:[dataSource courseId]]) {
        [self.courseProgress setProgress:progress];
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
@end
