//
//  CourseDrawerMediaCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/14/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseDrawerMediaCell.h"
#import "ResourceManager.h"

@implementation CourseDrawerMediaCell

-(void)setMedia:(Media *)media {
    _media = media;
    if (self.media.mediaType == EkkoMediaTypeImage) {
        [[ResourceManager sharedManager] getImageResource:[self.media resource] completeBlock:^(Resource *resource, UIImage *image) {
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mediaImageView setImage:image];
                });
            }
        }];
    }
    else {
        Resource *thumbnail = [self.media thumbnail];
        if (thumbnail) {
            [[ResourceManager sharedManager] getImageResource:thumbnail completeBlock:^(Resource *resource, UIImage *image) {
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mediaImageView setImage:image];
                    });
                }
            }];
        }
    }
}

@end
