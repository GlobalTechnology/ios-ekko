//
//  MultipleChoice+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/5/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MultipleChoice+Hub.h"

@implementation MultipleChoice (Hub)

-(void)addOptionsObject:(NSManagedObject *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.options];
    [orderedSet addObject:value];
    self.options = orderedSet;
}

@end
