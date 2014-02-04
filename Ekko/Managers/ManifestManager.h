//
//  ManifestManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest.h"

typedef NS_OPTIONS(NSUInteger, ManifestManagerOptions) {
    ManifestSkipCache    = (1<<0),
    ManifestSkipFile     = (1<<1),
    ManifestSkipDownload = (1<<2),
};

@interface ManifestManager : NSObject

+(ManifestManager *)sharedManager;

-(void)getManifest:(NSString *)courseId completeBlock:(void(^)(Manifest *manifest))complete;
-(void)getManifest:(NSString *)courseId withOptions:(ManifestManagerOptions)options completeBlock:(void(^)(Manifest *manifest))complete;


-(BOOL)hasManifestWithCourseId:(NSString *)courseId;
-(void)syncManifest:(NSString *)courseId complete:(void(^)())complete;
-(Manifest *)getManifestByCourseId:(NSString *)courseId;

@end
