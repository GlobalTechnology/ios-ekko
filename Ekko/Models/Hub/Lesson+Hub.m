//
//  Lesson+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Lesson+Hub.h"
#import "HubLessonPage.h"
#import "HubLessonMedia.h"
#import "CoreDataService.h"
#import "Page.h"
#import "Media.h"

@implementation Lesson (Hub)

-(void)addPagesObject:(Page *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.pages];
    [orderedSet addObject:value];
    self.pages = orderedSet;
}

-(void)addMediaObject:(Media *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.media];
    [orderedSet addObject:value];
    self.media = orderedSet;
}

-(void)updateWithHubLesson:(HubLesson *)hubLesson {
    [self setItemId:[hubLesson lessonId]];
    [self setItemTitle:[hubLesson lessonTitle]];
    
    self.pages = [NSMutableOrderedSet orderedSet];
    for (HubLessonPage *hubPage in hubLesson.pages) {
        Page *page = [[CoreDataService sharedService] newPageObject];
        [page setPageId:[hubPage pageId]];
        [page setPageText:[hubPage pageText]];
        [self addPagesObject:page];
    }
    
    self.media = [NSMutableOrderedSet orderedSet];
    for (HubLessonMedia *hubMedia in hubLesson.media) {
        Media *media = [[CoreDataService sharedService] newMediaObject];
        [media setMediaId:[hubMedia mediaId]];
        [media setMediaType:[hubMedia mediaType]];
        [media setResourceId:[hubMedia resourceId]];
        [media setThumbnailId:[hubMedia thumbnailId]];
        [self addMediaObject:media];
    }
}

@end
