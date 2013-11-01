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
    
    //Update Resources, update existing resources by resourceId, otherwise create new Resource
    NSMutableSet *resources = [NSMutableSet set];
    for (HubResource *hubResource in hubManifest.resources) {
        Resource *resource = [self resourceByResourceId:hubResource.resourceId];
        if (resource == nil) {
            resource = (Resource *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityManifestResource inManagedObjectContext:self.managedObjectContext];
        }
        [resource syncWithHubResource:hubResource];
        [resources addObject:resource];
    }
    //Delete any existing Resources not found in the new set of Resources
    NSMutableSet *oldResources = [NSMutableSet setWithSet:self.resources];
    [oldResources minusSet:resources];
    for (Resource *resource in oldResources) {
        [self.managedObjectContext deleteObject:resource];
    }
    [self setResources:resources];
    
    
    //Delete all existing Content
    for (ContentItem *item in self.content) {
        [self.managedObjectContext deleteObject:item];
    }
    //Create Lesson/Quiz content items
    [self setContent:[NSMutableOrderedSet orderedSet]];
    for (id contentItem in [hubManifest content]) {
        if ([contentItem isKindOfClass:[HubLesson class]]) {
            Lesson *lesson = (Lesson *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityLesson inManagedObjectContext:self.managedObjectContext];
            [lesson syncWithHubLesson:contentItem];
            [self addContentObject:lesson];
        }
        else if ([contentItem isKindOfClass:[HubQuiz class]]) {
            Quiz *quiz = (Quiz *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityQuiz inManagedObjectContext:self.managedObjectContext];
            [quiz syncWithHubQuiz:contentItem];
            [self addContentObject:quiz];
        }
    }
}

@end
