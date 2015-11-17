//
//  Course+Activity.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/6/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Course+Activity.h"

#import "ConfigManager.h"

@implementation Course (Activity)

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    NSURL *shareURL = [[ConfigManager sharedConfiguration].ekkolabsShareURL URLByAppendingPathComponent:[NSString stringWithFormat:@"/course/%@", self.courseId]];
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        return [shareURL absoluteString];
    }
    else if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        return shareURL;
    }
    return [shareURL absoluteString];
}

-(id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end
