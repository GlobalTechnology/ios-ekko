//
//  Lesson+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Lesson+Hub.h"
#import "DataManager.h"
#import "HubLessonPage.h"
#import "HubLessonMedia.h"
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

-(void)syncWithHubLesson:(HubLesson *)hubLesson {
    [self setItemId:[hubLesson lessonId]];
    [self setItemTitle:[hubLesson lessonTitle]];
    
    self.pages = [NSMutableOrderedSet orderedSet];
    for (HubLessonPage *hubPage in hubLesson.pages) {
        Page *page = (Page *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityPage inManagedObjectContext:self.managedObjectContext];
        [page setPageId:[hubPage pageId]];
        [page setPageText:[hubPage pageText]];
        [self addPagesObject:page];
    }
    
    self.media = [NSMutableOrderedSet orderedSet];
    for (HubLessonMedia *hubMedia in hubLesson.media) {
        Media *media = (Media *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityMedia inManagedObjectContext:self.managedObjectContext];
        [media setMediaId:[hubMedia mediaId]];
        [media setMediaType:[hubMedia mediaType]];
        [media setResourceId:[hubMedia resourceId]];
        [media setThumbnailId:[hubMedia thumbnailId]];
        [self addMediaObject:media];
    }
}

@end
