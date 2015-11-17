//
//  DrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "DrawerViewController.h"
#import <MMDrawerVisualState.h>
#import <TheKeyOAuth2Client.h>
#import <Routable/Routable.h>

#import "EkkoLoginViewController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

-(id)initWithCoder:(NSCoder *)aDecoder {
    UIStoryboard *storyboard;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"ekkoRootViewController"]
                      leftDrawerViewController:[storyboard instantiateViewControllerWithIdentifier:@"navigationDrawerViewController"]];

    // Assign centerViewController as the Routable Navigation Controller
    [[Routable sharedRouter] setNavigationController:(UINavigationController *)self.centerViewController];
    
    [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self setMaximumLeftDrawerWidth:260.0f];
    [self setMaximumRightDrawerWidth:260.0f];
    
    [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3.0f]];
    
    [self setShouldStretchDrawer:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theKeyOAuth2ClientDidChangeGuid:) name:TheKeyOAuth2ClientDidChangeGuidNotification object:[TheKeyOAuth2Client sharedOAuth2Client]];
    
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotate {
    return NO;
}

-(void)presentLoginDialog {
    [[TheKeyOAuth2Client sharedOAuth2Client] presentLoginViewController:[EkkoLoginViewController class] fromViewController:self loginDelegate:self];
}

-(void)theKeyOAuth2ClientDidChangeGuid:(NSNotification *)notification {
    [(UINavigationController *)self.centerViewController popToRootViewControllerAnimated:YES];
}

@end
