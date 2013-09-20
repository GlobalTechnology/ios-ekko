//
//  UIImage+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "UIImage+Ekko.h"

@implementation UIImage (Ekko)

+(UIImage *)imageNamed:(NSString *)name withTint:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:name];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    //Begin Image Context
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Translate CG coordinates to UI coordinates
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
/*
    // draw black background to preserve color of transparent pixels
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, rect);
    
    // draw original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // tint image (loosing alpha) - the luminosity of the original image is preserved
    CGContextSetBlendMode(context, kCGBlendModeColor);
    [color setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, image.CGImage);
*/

    // draw tint color
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [color setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
    CGContextDrawImage(context, rect, image.CGImage);
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
