//
//  UIImageView+Resource.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/11/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "UIImageView+Resource.h"
#import <objc/runtime.h>

@interface UIImageView (_Resource)
@property (nonatomic, strong) Resource *currentResource;
@end

@implementation UIImageView (_Resource)

-(Resource *)currentResource {
    return (Resource *)objc_getAssociatedObject(self, @selector(currentResource));
}

-(void)setCurrentResource:(Resource *)currentResource {
    objc_setAssociatedObject(self, @selector(currentResource), currentResource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIImageView (Resource)

-(void)setImageWithResource:(Resource *)resource {
    self.currentResource = resource;
    [[ResourceManager resourceManager] getImage:resource imageDelegate:self];
}

-(void)image:(UIImage *)image forResource:(Resource *)resource {
    if ([self.currentResource isEqual:resource]) {
        self.image = image;
        self.currentResource = nil;
    }
}

@end
