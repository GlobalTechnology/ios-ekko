//
//  Resource+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource.h"
#import "CourseIdProtocol.h"

typedef NS_ENUM(int16_t, EkkoResourceType) {
    EkkoResourceTypeUnknown = 0,
    EkkoResourceTypeFile    = 1,
    EkkoResourceTypeURI     = 2,
    EkkoResourceTypeDynamic = 3,
    EkkoResourceTypeECV     = 4,
};

typedef NS_ENUM(int16_t, EkkoResourceProvider) {
    EkkoResourceProviderUnknown = 0,
    EkkoResourceProviderNone    = 1,
    EkkoResourceProviderYouTube = 2,
    EkkoResourceProviderVimeo   = 3,
};

@interface Resource (Ekko) <CourseIdProtocol>

@property (nonatomic) EkkoResourceType type;
@property (nonatomic) EkkoResourceProvider provider;

-(BOOL)isFile;
-(BOOL)isUri;
-(BOOL)isEkkoCloudVideo;

/**
 Returns the filename used to store or retrieve the resource from disk
 */
-(NSString *)filenameOnDisk;

-(NSString *)youtTubeVideoId;

@end
