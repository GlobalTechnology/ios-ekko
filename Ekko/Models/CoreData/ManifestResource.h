//
//  ManifestResource.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Resource.h"

@class Manifest;

@interface ManifestResource : Resource

@property (nonatomic, retain) Manifest *course;

@end
