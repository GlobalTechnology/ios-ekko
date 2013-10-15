//
//  DrawerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "DrawerViewController.h"
#import <MMDrawerVisualState.h>

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
    self = [super initWithCenterViewController:[storyboard instantiateViewControllerWithIdentifier:@"ekkoNavigation"]
                      leftDrawerViewController:[storyboard instantiateViewControllerWithIdentifier:@"navigationDrawer"]];
    
    [self setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self setMaximumLeftDrawerWidth:200.0f];
    [self setMaximumRightDrawerWidth:260.0f];
    
    [self setDrawerVisualStateBlock:[MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3.0f]];
    
    [self setShouldStretchDrawer:NO];
    
    return self;
}

-(BOOL)shouldAutorotate {
    return NO;
}

@end
