//
//  ResourceManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/25/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Resource.h"

@protocol ResourceManagerDelegate;
@protocol ResourceManagerImageDelegate;

@interface ResourceManager : NSObject

+(ResourceManager *)sharedManager;

+(NSString *)pathForCourse:(NSString *)courseId;
-(NSString *)pathForCourse:(NSString *)courseId;

+(NSString *)pathForResource:(Resource *)resource;
-(NSString *)pathForResource:(Resource *)resource;

-(void)getImage:(Resource *)resource imageDelegate:(__weak id<ResourceManagerImageDelegate>)delegate;

-(void)getResource:(Resource *)resource progressBlock:(void (^)(Resource *resource, float progress))progressBlock completeBlock:(void (^)(Resource *resource, NSString *path))completeBlock;
-(void)getResource:(Resource *)resource delegate:(__weak id<ResourceManagerDelegate>)delegate;

@end

@protocol ResourceManagerImageDelegate <NSObject>
@required
-(void)image:(UIImage *)image forResource:(Resource *)resource;
@end

@protocol ResourceManagerDelegate <NSObject>
@required
-(void)resource:(Resource *)resource complete:(NSString *)path;
@optional
-(void)resource:(Resource *)resource progress:(float)progress;
@end
