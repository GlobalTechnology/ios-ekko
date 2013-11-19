//
//  AppDelegate.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AppDelegate.h"
#import <TheKeyOAuth2Client.h>
#import <AFNetworking.h>
#import "CourseManager.h"
#import "EkkoLoginViewController.h"

@interface AppDelegate ()
-(void)showLoginDialog;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Activate Network Activity handling in AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Sync Courses
    TheKeyOAuth2Client *theKey = [TheKeyOAuth2Client sharedOAuth2Client];
    NSLog(@"GUID: %@", [theKey guid]);
    [theKey logout];
    if([theKey isAuthenticated]) {
        [[CourseManager sharedManager] syncAllCoursesFromHub];
    }
    else {
        [self performSelector:@selector(showLoginDialog) withObject:nil afterDelay:0.1f];
    }

    return YES;
}
							
-(void)showLoginDialog {
    [[TheKeyOAuth2Client sharedOAuth2Client] presentLoginViewController:[EkkoLoginViewController class] fromViewController:self.window.rootViewController loginDelegate:nil];
}

-(void)loginSuccess {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
    [[CourseManager sharedManager] syncAllCoursesFromHub];
}

-(void)loginFailure {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
