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
        [[ResourceService sharedService] getResource:[self.media resource] delegate:self];
    }
    else {
        Resource *thumbnail = [self.media thumbnail];
        if (thumbnail) {
            [[ResourceService sharedService] getResource:[self.media thumbnail] delegate:self];
        }
    }
}

-(void)resourceService:(Resource *)resource image:(UIImage *)image {
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaImage setImage:image];
        });
    }
}

@end
