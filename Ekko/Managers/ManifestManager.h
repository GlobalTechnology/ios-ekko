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

FOUNDATION_EXPORT NSString *const EkkoManifestManagerDidSyncManifestNotification;

@interface ManifestManager : NSObject

+(ManifestManager *)manifestManager;

-(void)getManifest:(NSString *)courseId withOptions:(ManifestManagerOptions)options completeBlock:(void(^)(Manifest *manifest))complete;
-(void)syncManifest:(NSString *)courseId completeBlock:(void(^)(Manifest *manifest))complete;

@end
