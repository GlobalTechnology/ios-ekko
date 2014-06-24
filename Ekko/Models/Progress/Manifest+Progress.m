//
//  Manifest+Progress.m
//  Ekko
//
//  Created by Brian Zoetewey on 3/21/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Manifest+Progress.h"
#import "ContentItem.h"

#import "Lesson+Progress.h"

@implementation Manifest (Progress)

-(NSMutableSet *)progressItems {
    NSMutableSet *set = [NSMutableSet set];
    for (ContentItem *item in self.content) {
        if ([item conformsToProtocol:@protocol(ProgressItems)]) {
            [set unionSet:[(id<ProgressItems>)item progressItems]];
        }
    }
    return set;
}

@end
