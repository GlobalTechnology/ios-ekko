//
//  UIImageView+Resource.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/11/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResourceManager.h"
#import "Resource.h"

@interface UIImageView (Resource) <ResourceManagerImageDelegate>

-(void)setImageWithResource:(Resource *)resource;

@end
