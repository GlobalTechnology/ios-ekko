//
//  DataManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "DataManager.h"

NSString *const EkkoEntities[] = {
    [EkkoCourseEntity]               = @"Course",
    [EkkoManifestEntity]             = @"Manifest",
    [EkkoResourceEntity]             = @"Resource",
    [EkkoLessonEntity]               = @"Lesson",
    [EkkoQuizEntity]                 = @"Quiz",
    [EkkoPageEntity]                 = @"Page",
    [EkkoMediaEntity]                = @"Media",
    [EkkoMultipleChoiceEntity]       = @"MultipleChoice",
    [EkkoMultipleChoiceOptionEntity] = @"MultipleChoiceOption",
    [EkkoProgressItemEntity]         = @"ProgressItem",
    [EkkoAnswerEntity]               = @"Answer",
};

@interface DataManager ()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation DataManager

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(DataManager *)dataManager {
    __strong static DataManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[DataManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"Ekko" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
    }
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *persistenStorePath = [applicationDocumentsDirectory URLByAppendingPathComponent:@"Ekko.sqlite"];
        
        //Debug - Delete Previous Database
        [[NSFileManager defaultManager] removeItemAtURL:persistenStorePath error:nil];
        
        NSError *error = nil;
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenStorePath options:nil error:&error]) {
            NSLog(@"Unresolved Error: %@, %@", error, error.userInfo);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

-(void)handleContextDidSaveNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[NSManagedObjectContext class]]) {
        NSManagedObjectContext *managedObjectContext = (NSManagedObjectContext *)notification.object;
        if (self.managedObjectContext != managedObjectContext) {
            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }
    }
}

-(NSManagedObjectContext *)mainQueueManagedObjectContext {
    return self.managedObjectContext;
}

-(NSManagedObjectContext *)newPrivateQueueManagedObjectContext {
    NSManagedObjectContext *privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [privateManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    return privateManagedObjectContext;
}

-(NSString *)nameForEntity:(EkkoEntity)entity {
    return (NSString *)EkkoEntities[entity];
}

-(NSEntityDescription *)entityDescriptionForEntity:(EkkoEntity)entity {
    return (NSEntityDescription *)[[self.managedObjectModel entitiesByName] objectForKey:[self nameForEntity:entity]];
}

-(NSManagedObject *)insertNewObjectForEntity:(EkkoEntity)entity inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:[self nameForEntity:entity] inManagedObjectContext:managedObjectContext];
}

-(NSFetchRequest *)fetchRequestForEntity:(EkkoEntity)entity {
    return [NSFetchRequest fetchRequestWithEntityName:[self nameForEntity:entity]];
}

-(void)saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSError *error = nil;
    [managedObjectContext save:&error];
}

-(Manifest *)insertNewManifestInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return (Manifest *)[self insertNewObjectForEntity:EkkoManifestEntity inManagedObjectContext:managedObjectContext];
}

-(Manifest *)getManifestByCourseId:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [self fetchRequestForEntity:EkkoManifestEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (results != nil && [results count] > 0) {
        return (Manifest *)[results firstObject];
    }
    return nil;
}

-(Course *)insertNewCourseInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return (Course *)[self insertNewObjectForEntity:EkkoCourseEntity inManagedObjectContext:managedObjectContext];
}

-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [self fetchRequestForEntity:EkkoCourseEntity];
    NSArray *courses = [managedObjectContext executeFetchRequest:request error:nil];
    if (courses != nil) {
        return courses;
    }
    return [NSArray array];
}

-(NSFetchedResultsController *)coursesFetchedResultsController {
    NSFetchRequest *request = [self fetchRequestForEntity:EkkoCourseEntity];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseTitle" ascending:YES]]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self mainQueueManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

@end
