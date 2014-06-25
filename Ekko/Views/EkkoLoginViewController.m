//
//  EkkoLoginViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 11/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "EkkoLoginViewController.h"
#import "UIColor+Ekko.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

@implementation EkkoLoginViewController

+(NSString *)authNibName {
    return @"EkkoLoginViewController";
}

-(void)viewWillAppear:(BOOL)animated {
    self.webView.backgroundColor = [UIColor ekkoDarkBlue];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Login"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
