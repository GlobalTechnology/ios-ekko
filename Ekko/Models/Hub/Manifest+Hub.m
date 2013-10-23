//
//  Manifest+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest+Hub.h"
#import "Manifest+Ekko.h"

#import "Resource+Hub.h"
#import "Lesson+Hub.h"
#import "Quiz+Hub.h"

#import "DataManager.h"

@implementation Manifest (Hub)

-(void)addContentObject:(ContentItem *)value {
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.content];
    [orderedSet addObject:value];
    self.content = orderedSet;
}

-(void)syncWithHubManifest:(HubManifest *)hubManifest {
    //Update Manifest if it is a new object or version number has changed
    if ([[self objectID] isTemporaryID] || [hubManifest courseVersion] > [self courseVersion]) {
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
        
        NSMutableSet *resources = [NSMutableSet set];
        for (HubResource *hubResource in hubManifest.resources) {
            Resource *resource = [self resourceByResourceId:hubResource.resourceId];
            if (resource == nil) {
                resource = (Resource *)[[DataManager dataManager] insertNewObjectForEntity:EkkoEntityManifestResource inManagedObjectContext:self.managedObjectContext];
            }
            [resource syncWithHubResource:hubResource];
            [resources addObject:resource];
        }
        [self setResources:resources];
        
        [self setContent:[NSMutableOrderedSet orderedSet]];
        for (id contentItem in [hubManifest content]) {
            if ([contentItem isKindOfClass:[HubLesson class]]) {
                Lesson *lesson = (Lesson *)[[DataManager dataManager] insertNewObjectForEntity:EkkoEntityLesson inManagedObjectContext:self.managedObjectContext];
                [lesson syncWithHubLesson:contentItem];
                [self addContentObject:lesson];
            }
            else if ([contentItem isKindOfClass:[HubQuiz class]]) {
                Quiz *quiz = (Quiz *)[[DataManager dataManager] insertNewObjectForEntity:EkkoEntityQuiz inManagedObjectContext:self.managedObjectContext];
                [quiz syncWithHubQuiz:contentItem];
                [self addContentObject:quiz];
            }
        }
    }
}

@end
