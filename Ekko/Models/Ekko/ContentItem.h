//
//  ContentItem.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest.h"

typedef NS_ENUM(NSUInteger, EkkoContentType) {
    EkkoContentTypeUnknown = 0,
    EkkoContentTypeQuiz    = 1,
    EkkoContentTypeLesson  = 2,
};

@interface ContentItem : NSObject <ManifestProperty>

@property (nonatomic, strong) NSString *contentId;
@property (nonatomic, readonly) EkkoContentType contentType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) Manifest *manifest;

@end
