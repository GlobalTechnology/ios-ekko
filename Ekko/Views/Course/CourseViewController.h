//
//  CourseViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
#import "Manifest+Ekko.h"

@interface CourseViewController : SwipeViewController <SwipeViewControllerDelegate>

@property (nonatomic, strong) Manifest *manifest;

@end
