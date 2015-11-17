//
//  AboutEkkoViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "AboutEkkoViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "UIImage+Ekko.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

@implementation AboutEkkoViewController

+(id)allocWithRouterParams:(NSDictionary *)params {
    UIStoryboard *storyboard = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] storyboard];
    AboutEkkoViewController *aboutController = [storyboard instantiateViewControllerWithIdentifier:@"aboutEkkoViewController"];
    return aboutController;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *toggleDrawer = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleDrawer setFrame:CGRectMake(0, 0, 34, 34)];
    [toggleDrawer setShowsTouchWhenHighlighted:YES];
    [toggleDrawer setImage:[UIImage imageNamed:@"ShowLines" withTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    [toggleDrawer addTarget:self action:@selector(toggleNavigationDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toggleDrawer]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *aboutUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AboutEkko" ofType:@"html"]];
    [self.aboutWebView loadRequest:[NSURLRequest requestWithURL:aboutUrl]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"About"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (IBAction)toggleNavigationDrawer:(id)sender {
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
