//
//  Media.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Media.h"

@implementation Media

-(Resource *)resource {
    return [self.manifest resourceByResourceId:self.resourceId];
}

-(Resource *)thumbnail {
    return [self.manifest resourceByResourceId:self.thumbnailId];
}

@end
