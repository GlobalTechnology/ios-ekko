//
//  Manifest.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Manifest.h"

@implementation Manifest

@synthesize content   = _content;
@synthesize resources = _resources;

-(NSMutableOrderedSet *)content {
    if (!_content) {
        _content = [NSMutableOrderedSet orderedSet];
    }
    return _content;
}

-(NSMutableSet *)resources {
    if (!_resources) {
        _resources = [NSMutableSet set];
    }
    return _resources;
}

@end
