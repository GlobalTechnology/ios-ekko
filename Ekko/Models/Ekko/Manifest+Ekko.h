//
//  Manifest+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest.h"
#import "SwipeViewController.h"
#import "ContentItemProtocol.h"
#import "ProgressManager.h"

@interface Manifest (Ekko) <SwipeViewControllerDataSource, ProgressManagerDataSource>

-(Resource *)resourceByResourceId:(NSString *)resourceId;

-(NSUInteger)indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController;
-(UIViewController<ContentItemProtocol> *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

@end
