//
//  Manifest.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manifest : NSObject //<NSDiscardableContent>

@property (strong, nonatomic) NSString *courseId;
@property (nonatomic) NSInteger courseVersion;
@property (nonatomic, strong) NSString *courseTitle;

@property (nonatomic, strong, readonly) NSMutableOrderedSet *content;
@property (nonatomic, strong, readonly) NSMutableSet *resources;

@property (nonatomic, strong) NSString *completeMessage;

@end

@protocol ManifestProperty <NSObject>
@required
@property (nonatomic, weak) Manifest *manifest;
@end