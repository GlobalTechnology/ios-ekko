//
//  Media.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest.h"

typedef NS_ENUM(NSUInteger, EkkoMediaType) {
    EkkoMediaTypeUnknown = 0,
    EkkoMediaTypeImage   = 1,
    EkkoMediaTypeVideo   = 2,
    EkkoMediaTypeAudio   = 3,
};

@interface Media : NSObject <ManifestProperty>

@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic) EkkoMediaType mediaType;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *thumbnailId;
@property (nonatomic, weak) Manifest *manifest;

@end
