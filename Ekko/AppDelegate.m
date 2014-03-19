//
//  AppDelegate.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AppDelegate.h"
#import <TheKeyOAuth2Client.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <NewRelicAgent/NewRelic.h>
#import "CourseManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Activate New Relic Application reporting
    [NewRelicAgent startWithApplicationToken:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NewRelicApplicationToken"]];

    // Activate Network Activity handling in AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    // Set entire app StatusBar style to light
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Listen for GUID change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theKeyOAuth2ClientDidChangeGuidNotification:)
                                                 name:TheKeyOAuth2ClientDidChangeGuidNotification
                                               object:[TheKeyOAuth2Client sharedOAuth2Client]];

    //Sync Courses
    [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] syncCourses];

    return YES;
}

-(void)theKeyOAuth2ClientDidChangeGuidNotification:(NSNotification *)notification {
    [[CourseManager courseManagerForGUID:[(TheKeyOAuth2Client *)notification.object guid]] syncCourses];
}



@end
