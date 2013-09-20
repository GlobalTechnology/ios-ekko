//
//  Course+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course+Ekko.h"

@implementation Course (Ekko)

-(Resource *)bannerResource {
    if ([self.resources count] > 0) {
        //Courses have only one resource, so anyObject will return the only object.
        return (Resource *)[self.resources anyObject];
    }
    return nil;
}

@end
