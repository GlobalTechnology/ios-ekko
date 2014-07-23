//
//  AppDelegate.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigManager.h"
#import <TheKeyOAuth2Client.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <NewRelicAgent/NewRelic.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import "EventTracker.h"
#import "CourseManager.h"

#import "DrawerViewController.h"
#import "CourseDetailsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if defined (EKKOLABS_DEBUG)
    [[UIApplication sharedApplication] performSelector:@selector(setApplicationBadgeString:) withObject:@"dev"];
#endif

    // Initialize and configure TheKeyOAuth2 Client
    [[TheKeyOAuth2Client sharedOAuth2Client] setServerURL:[ConfigManager sharedConfiguration].theKeyOAuth2ServerURL
                                                 clientId:[ConfigManager sharedConfiguration].theKeyOAuth2ClientID];

    // Activate New Relic Application Monitoring
    [NewRelicAgent startWithApplicationToken:[ConfigManager sharedConfiguration].NewRelicApplicationToken];

    // Activate Google Analytics Tracking
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:[ConfigManager sharedConfiguration].googleAnalyticsTrackingID];


    // Activate Network Activity handling in AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    // Initialize Arclight EventTracker
    [EventTracker initializeWithApiKey:[ConfigManager sharedConfiguration].arclightAPIKey
                             appDomain:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
                               appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
                            appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

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

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [EventTracker applicationDidBecomeActive];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DrawerViewController *drawerViewController = (DrawerViewController *)self.window.rootViewController;
    UINavigationController *rootNavigationController = (UINavigationController *) drawerViewController.centerViewController;

    NSArray *components = [[url absoluteURL] pathComponents];
    if ([components count] > 1 && [[components firstObject] isEqualToString:@"/"]) {
        NSString *type = [components objectAtIndex:1];
        NSString *item_id = ([components count] > 2) ? [components objectAtIndex:2] : nil;

        UIViewController *viewController = nil;
        if ([type isEqualToString:@"course"]) {
            viewController = [rootNavigationController.storyboard instantiateViewControllerWithIdentifier:@"courseDetailsViewController"];
        }
        else if ([type isEqualToString:@"playlist"]) {
            viewController = nil;
        }

        if (viewController) {
            //    [rootNavigationController setViewControllers:@[courseDetails]];
            [rootNavigationController pushViewController:viewController animated:YES];
            return YES;
        }
    }
    return NO;
}

-(void)theKeyOAuth2ClientDidChangeGuidNotification:(NSNotification *)notification {
    NSString *guid = [notification.userInfo objectForKey:TheKeyOAuth2ClientGuidKey];
    [[CourseManager courseManagerForGUID:guid] syncCourses];
}

@end
