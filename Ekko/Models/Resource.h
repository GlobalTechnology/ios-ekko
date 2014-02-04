//
//  NewResource.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest.h"

typedef NS_ENUM(NSUInteger, EkkoResourceType) {
    EkkoResourceTypeUnknown  = 0,
    EkkoResourceTypeFile     = 1,
    EkkoResourceTypeURI      = 2,
    EkkoResourceTypeDynamic  = 3,
    EkkoResourceTypeECV      = 4,
    EkkoResourceTypeArclight = 5,
};

typedef NS_ENUM(NSUInteger, EkkoResourceProvider) {
    EkkoResourceProviderUnknown = 0,
    EkkoResourceProviderNone    = 1,
    EkkoResourceProviderYouTube = 2,
    EkkoResourceProviderVimeo   = 3,
};

@interface Resource : NSObject <ManifestProperty>

@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic) EkkoResourceType type;
@property (nonatomic) unsigned long long size;
@property (nonatomic, strong) NSString *sha1;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic) EkkoResourceProvider provider;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, strong) NSString *videoId;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, weak) Manifest *manifest;

@end
