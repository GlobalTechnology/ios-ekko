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

+(UIImage *)inflatedImage:(NSData *)data scale:(CGFloat)scale {
    if (!data || [data length] == 0) {
        return nil;
    }
    
    
    UIImage *image = [[UIImage alloc] initWithData:data scale:scale];
    if (image.images) {
        return image;
    }
    CGImageRef imageRef = CGImageCreateCopy([image CGImage]);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bytesPerRow = 0; // CGImageGetBytesPerRow() calculates incorrectly in iOS 5.0, so defer to CGBitmapContextCreate()
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    if (CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        int alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        CGImageRelease(imageRef);
        
        return [[UIImage alloc] initWithData:data];
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}

@end
