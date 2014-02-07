//
//  Page.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manifest.h"

@interface Page : NSObject <ManifestProperty>

@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSString *pageText;
@property (nonatomic, weak) Manifest *manifest;

@end
