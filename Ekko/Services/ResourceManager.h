//
//  ResourceManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/25/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Resource+Ekko.h"

@protocol ResourceManagerDelegate;

@interface ResourceManager : NSObject

+(ResourceManager *)resourceManager;

-(void)getImageResource:(Resource *)resource completeBlock:(void (^)(Resource *resource, UIImage *image))completeBlock;
-(void)getResource:(Resource *)resource progressBlock:(void (^)(Resource *resource, float progress))progressBlock completeBlock:(void (^)(Resource *resource, NSString *path))completeBlock;
-(void)getResource:(Resource *)resource delegate:(__weak id<ResourceManagerDelegate>)delegate;

@end

@protocol ResourceManagerDelegate <NSObject>
@required
-(void)resource:(Resource *)resource complete:(NSString *)path;
@optional
-(void)resource:(Resource *)resource progress:(float)progress;
@end
