//
//  CourseDrawerMediaCell.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/14/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseDrawerMediaCell.h"
#import "ResourceManager.h"
#import "UIImageView+Resource.h"

@implementation CourseDrawerMediaCell

-(void)setMedia:(Media *)media {
    _media = media;
    Resource *resource = (self.media.mediaType == EkkoMediaTypeImage) ? [self.media resource] : [self.media thumbnail];
    if (resource) {
        [self.mediaImageView setImageWithResource:resource];
    }
}

@end
