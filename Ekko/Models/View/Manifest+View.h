//
//  Manifest+View.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest.h"
#import "Resource.h"
#import "SwipeViewController.h"
#import "ContentItemProtocol.h"

@interface Manifest (View) <SwipeViewControllerDataSource>

-(NSUInteger)indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController;
-(UIViewController<ContentItemProtocol> *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

@end
