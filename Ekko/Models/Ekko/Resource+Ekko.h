//
//  Resource+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource.h"

typedef NS_ENUM(int16_t, EkkoResourceType) {
    EkkoResourceTypeUnknown = -1,
    EkkoResourceTypeFile    = 0,
    EkkoResourceTypeURI     = 1,
    EkkoResourceTypeDynamic = 2,
};

typedef NS_ENUM(int16_t, EkkoResourceProvider) {
    EkkoResourceProviderUnknown = -1,
    EkkoResourceProviderNone    = 0,
    EkkoResourceProviderYouTube = 1,
    EkkoResourceProviderVimeo   = 2,
};

@interface Resource (Ekko)

@property (nonatomic) EkkoResourceType type;
@property (nonatomic) EkkoResourceProvider provider;
@property (nonatomic, readonly) NSString *courseId;

-(NSURL *)imageUrl;

-(BOOL)isFile;
-(BOOL)isUri;

@end
