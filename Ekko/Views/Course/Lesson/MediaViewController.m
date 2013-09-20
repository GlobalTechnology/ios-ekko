//
//  MediaViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MediaViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Resource+Ekko.h"
#import "HubClient.h"

@interface MediaViewController ()

@end

@implementation MediaViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.media.mediaType isEqualToString:@"image"]) {
        Resource *resource = [self.media resource];
        if (resource) {
            [self.mediaImage setImageWithURL:[resource imageUrl]];
        }
    }
    else {
        Resource *thumbnail = [self.media thumbnail];
        if (thumbnail) {
            [self.mediaImage setImageWithURL:[thumbnail imageUrl]];
        }
    }
}

@end
