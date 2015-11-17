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
#import <Routable/Routable.h>
#import "EventTracker.h"

#import "CourseManager.h"

#import "DrawerViewController.h"
#import "AboutCourseViewController.h"
#import "AboutEkkoViewController.h"
#import "CourseListViewController.h"
#import "CourseViewController.h"

#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#ifdef EKKOLABS_DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[UIApplication sharedApplication] performSelector:@selector(setApplicationBadgeString:) withObject:@"DEV"];
#pragma clang diagnostic pop
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
    [[AFNetworkActivityLogger sharedLogger] startLogging];

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

    // Configure Routable UIViewControllers
    Routable *router = [Routable sharedRouter];
    [router map:@"course/:courseId" toController:[AboutCourseViewController class]];

    [router map:@"manifest/:courseId" toController:[CourseViewController class]];

    [router map:@"courses/my" toController:[CourseListViewController class] withOptions:[[UPRouterOptions root] forDefaultParams:@{@"fetchType": @(EkkoMyCoursesFetchType)}]];
    [router map:@"courses/all" toController:[CourseListViewController class] withOptions:[[UPRouterOptions root] forDefaultParams:@{@"fetchType": @(EkkoAllCoursesFetchType)}]];
    [router map:@"courses/playlist/:playlistId" toController:[CourseListViewController class] withOptions:[[UPRouterOptions root] forDefaultParams:@{@"fetchType": @(EkkoAllCoursesFetchType)}]];

    [router map:@"about" toController:[AboutEkkoViewController class] withOptions:[UPRouterOptions root]];
    [router map:@"login" toCallback:^(NSDictionary *params) {
        [(DrawerViewController *)self.window.rootViewController presentLoginDialog];
    }];
    [router map:@"logout" toCallback:^(NSDictionary *params) {
        [[TheKeyOAuth2Client sharedOAuth2Client] logout];
    }];

    //Sync Courses
    [[CourseManager courseManagerForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] syncCourses];

    return YES;
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    [EventTracker applicationDidBecomeActive];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // ekkolabs:///course/1179114091462545382

    NSArray *components = [[url absoluteURL] pathComponents];
    if ([components count] > 1 && [[components firstObject] isEqualToString:@"/"]) {
        // Strip leading /
        components = [components subarrayWithRange:NSMakeRange(1, [components count] - 1)];
        @try {
            [[Routable sharedRouter] open:[components componentsJoinedByString:@"/"] animated:NO];
            return YES;
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
    return NO;
}

-(void)theKeyOAuth2ClientDidChangeGuidNotification:(NSNotification *)notification {
    NSString *guid = [notification.userInfo objectForKey:TheKeyOAuth2ClientGuidKey];
    [[CourseManager courseManagerForGUID:guid] syncCourses];
}

@end
