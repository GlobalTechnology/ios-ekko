//
//  Media+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Media+Ekko.h"
#import "Lesson+Ekko.h"
#import "Manifest+Ekko.h"

@implementation Media (Ekko)

-(Resource *)resource {
    return [self.manifest resourceByResourceId:self.resourceId];
}

-(Resource *)thumbnail {
    return [self.manifest resourceByResourceId:self.thumbnailId];
}

@end
