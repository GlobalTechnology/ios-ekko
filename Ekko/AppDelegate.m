//
//  AppDelegate.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking.h>
#import "HubSyncService.h"

@interface AppDelegate ()
-(void)showLoginDialog;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Activate Network Activity handling in AFNetworking
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if([[TheKey theKey] canAuthenticate]) {
        [[HubSyncService sharedService] syncCourses];
    }
    else {
        [self performSelector:@selector(showLoginDialog) withObject:nil afterDelay:0.1];
    }

    return YES;
}
							
-(void)showLoginDialog {
    UIViewController *loginDialog = [[TheKey theKey] showDialog:self];
    [loginDialog setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.window.rootViewController presentViewController:loginDialog animated:YES completion:^{}];
}

-(void)loginSuccess {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
    [[HubSyncService sharedService] syncCourses];
}

-(void)loginFailure {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
