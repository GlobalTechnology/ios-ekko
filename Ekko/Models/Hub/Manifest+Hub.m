//
//  Manifest+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest+Hub.h"
#import "DataManager.h"

#import "Resource+Hub.h"
#import "Lesson+Hub.h"
#import "Quiz+Hub.h"

@implementation Manifest (Hub)

-(void)addContentObject:(ContentItem *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.content];
    [orderedSet addObject:value];
    self.content = orderedSet;
}

-(void)updateWithHubManifest:(HubManifest *)hubManifest {
    //Update Manifest if it is a new object or version number has changed
    if ([[self objectID] isTemporaryID] || [hubManifest courseVersion] > [self courseVersion]) {
        //Update Last Synced to NOW
        [self setLastSynced:[[NSDate date] timeIntervalSince1970]];
        
        [self setCourseId:[hubManifest courseId]];
        [self setCourseVersion:[hubManifest courseVersion]];
        
        HubMeta *hubMeta = [hubManifest courseMeta];
        [self setCourseTitle:[hubMeta courseTitle]];
        [self setCourseDescription:[hubMeta courseDescription]];
        [self setAuthorName:[hubMeta authorName]];
        [self setAuthorEmail:[hubMeta authorEmail]];
        [self setAuthorUrl:[hubMeta authorUrl]];
        [self setCourseCopyright:[hubMeta courseCopyright]];
        
        [self setCompleteMessage:[hubManifest completeMessage]];

        [self setResources:[NSMutableSet set]];
        for (HubResource *hubResource in [hubManifest resources]) {
            Resource *resource = (Resource *)[[DataManager dataManager] insertNewObjectForEntity:EkkoResourceEntity inManagedObjectContext:self.managedObjectContext];
            [resource updateFromHubResource:hubResource];
            [self addResourcesObject:resource];
        }
        
        [self setContent:[NSMutableOrderedSet orderedSet]];
        for (id contentItem in [hubManifest content]) {
            if ([contentItem isKindOfClass:[HubLesson class]]) {
                Lesson *lesson = (Lesson *)[[DataManager dataManager] insertNewObjectForEntity:EkkoLessonEntity inManagedObjectContext:self.managedObjectContext];
                [lesson updateWithHubLesson:contentItem];
                [self addContentObject:lesson];
            }
            else if ([contentItem isKindOfClass:[HubQuiz class]]) {
                Quiz *quiz = (Quiz *)[[DataManager dataManager] insertNewObjectForEntity:EkkoQuizEntity inManagedObjectContext:self.managedObjectContext];
                [quiz updateWithHubQuiz:contentItem];
                [self addContentObject:quiz];
            }
        }
    }
}

@end
