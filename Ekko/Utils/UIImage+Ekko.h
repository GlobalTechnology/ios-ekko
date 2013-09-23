//
//  UIImage+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Ekko)

+(UIImage *)imageNamed:(NSString *)name withTint:(UIColor *)color;

+(UIImage *)inflatedImage:(NSData *)data scale:(CGFloat)scale;

@end
