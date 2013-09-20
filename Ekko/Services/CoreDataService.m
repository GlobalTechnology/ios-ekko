//
//  CoreDataService.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CoreDataService.h"

NSString *const EkkoCoreDataEntities[] = {
    [EkkoCoreDataEntityCourse]     = @"Course",
    [EkkoCoreDataEntityManifest]   = @"Manifest",
    [EkkoCoreDataEntityResource]   = @"Resource",
    [EkkoCoreDataEntityLesson]     = @"Lesson",
    [EkkoCoreDataEntityQuiz]       = @"Quiz",
    [EkkoCoreDataEntityPage]       = @"Page",
    [EkkoCoreDataEntityMedia]      = @"Media",
    [EkkoCoreDataEntityMultipleChoice] = @"MultipleChoice",
    [EkkoCoreDataEntityMultipleChoiceOption] = @"MultipleChoiceOption",
};

@implementation CoreDataService

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(CoreDataService *)sharedService {
    __strong static CoreDataService *_service = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _service = [[CoreDataService alloc] init];
    });
    return _service;
}

-(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if(coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel {
    if(_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Ekko" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Ekko.sqlite"];

        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        NSError *error = nil;

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

-(NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if(context != nil) {
        if([context hasChanges] && ![context save:&error]) {
            NSLog(@"Core Data Save Error %@, %@", error, [error userInfo]);
        }
    }
}

-(NSString *)nameFromEntityType:(EkkoCoreDataEntity)entityType {
    return (NSString *)EkkoCoreDataEntities[entityType];
}

-(NSManagedObject *)newObjectForEntityType:(EkkoCoreDataEntity)entityType {
    return [NSEntityDescription insertNewObjectForEntityForName:[self nameFromEntityType:entityType] inManagedObjectContext:[self managedObjectContext]];
}

#pragma mark - Course
-(Course *)newCourseObject {
    return (Course *)[self newObjectForEntityType:EkkoCoreDataEntityCourse];
}

-(NSArray *)getAllCourseObjects {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[self nameFromEntityType:EkkoCoreDataEntityCourse]];
    NSError *error = nil;
    NSArray *courses = [[self managedObjectContext] executeFetchRequest:fetch error:&error];
    //TODO: handle error
    return courses;
}

-(NSFetchedResultsController *)courseFetchedResultsController {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[self nameFromEntityType:EkkoCoreDataEntityCourse]];
    [fetch setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseTitle" ascending:YES]]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

#pragma mark - Manifest
-(Manifest *)newManifestObject {
    return (Manifest *)[self newObjectForEntityType:EkkoCoreDataEntityManifest];
}

-(Manifest *)getManifestObjectByCourseId:(NSString *)courseId {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:[self nameFromEntityType:EkkoCoreDataEntityManifest]];
    [fetch setPredicate:[NSPredicate predicateWithFormat:@"courseId = %@", courseId]];
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:fetch error:&error];
    if (results != nil && [results count] > 0) {
        return (Manifest *)[results objectAtIndex:0];
    }
    return nil;
}

#pragma mark - Resource
-(Resource *)newResourceObject {
    return (Resource *)[self newObjectForEntityType:EkkoCoreDataEntityResource];
}

#pragma mark - Lesson
-(Lesson *)newLessonObject {
    return (Lesson *)[self newObjectForEntityType:EkkoCoreDataEntityLesson];
}

#pragma mark - Quiz
-(Quiz *)newQuizObject {
    return (Quiz *)[self newObjectForEntityType:EkkoCoreDataEntityQuiz];
}

#pragma mark - Page
-(Page *)newPageObject {
    return (Page *)[self newObjectForEntityType:EkkoCoreDataEntityPage];
}

#pragma mark - Media
-(Media *)newMediaObject {
    return (Media *)[self newObjectForEntityType:EkkoCoreDataEntityMedia];
}

#pragma mark - Question
-(MultipleChoice *)newMultipleChoiceObject {
    return (MultipleChoice *)[self newObjectForEntityType:EkkoCoreDataEntityMultipleChoice];
}

-(MultipleChoiceOption *)newMultipleChoiceOptionObject {
    return (MultipleChoiceOption *)[self newObjectForEntityType:EkkoCoreDataEntityMultipleChoiceOption];
}

@end
