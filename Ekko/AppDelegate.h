//
//  AppDelegate.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TheKey.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TheKeyLoginDialogDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
