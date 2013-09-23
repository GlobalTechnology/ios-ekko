//
//  ResourceService.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/16/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Resource+Ekko.h"

@protocol ResourceServiceImageDelegate;

@interface ResourceService : NSObject

/**
 Returns the ResourceService singleton instance
 */
+(ResourceService *)sharedService;

-(void)getResource:(Resource *)resource delegate:(__weak id<ResourceServiceImageDelegate>)delegate;

@end

@protocol ResourceServiceImageDelegate <NSObject>
@required
-(void)resourceService:(Resource *)resource image:(UIImage *)image;
@end