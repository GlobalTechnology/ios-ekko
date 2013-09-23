//
//  CourseListCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseListCell.h"
#import "ResourceService.h"

//#import "Resource+Ekko.h"
//#import "UIColor+Ekko.h"

static const int insetViewTag = 1;

@implementation CourseListCell

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIView *insetView = [self viewWithTag:1];
    insetView.layer.masksToBounds = NO;
    insetView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    insetView.layer.shadowColor = [[UIColor blackColor] CGColor];
    insetView.layer.shadowRadius = 2.0f;
    insetView.layer.shadowOpacity = 0.5f;
    insetView.layer.shadowPath = [UIBezierPath bezierPathWithRect:insetView.bounds].CGPath;    
}

-(void)setCourse:(Course *)course {
    _course = course;
    Resource *banner = [course bannerResource];
    [self.banner setImage:nil];
    if (banner) {
        [[ResourceService sharedService] getResource:banner delegate:self];
    }
    [self.courseTitle setText:[course courseTitle]];
}

-(void)resourceService:(Resource *)resource image:(UIImage *)image {
    Resource *banner = [self.course bannerResource];
    if (image && resource == banner) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.banner setImage:image];
        });
    }
}

@end
