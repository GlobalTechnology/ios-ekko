//
//  Lesson+Progress.m
//  Ekko
//
//  Created by Brian Zoetewey on 3/26/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Lesson+Progress.h"

#import "Page.h"
#import "Media.h"

@implementation Lesson (Progress)
-(NSMutableSet *)progressItems {
    NSMutableSet *set = [NSMutableSet set];

    for (Page *page in self.pages) {
        [set addObject:[page.pageId copy]];
    }

    for (Media *media in self.media) {
        [set addObject:[media.mediaId copy]];
    }
    return set;
}
@end
