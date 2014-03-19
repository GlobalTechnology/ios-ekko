//
//  CoreDataManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoreDataManager.h"

NSString *const EkkoEntityTypes[] = {
    [EkkoEntityCourse]     = @"Course",
    [EkkoEntityAnswer]     = @"Answer",
    [EkkoEntityPermission] = @"Permission",
    [EkkoEntityBanner]     = @"Banner",
};

@interface CoreDataManager ()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation CoreDataManager

@synthesize managedObjectContext       = _managedObjectContext;
@synthesize managedObjectModel         = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(CoreDataManager *)sharedManager {
    __strong static CoreDataManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[CoreDataManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
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

        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenStorePath options:nil error:&error]) {
            [[NSFileManager defaultManager] removeItemAtURL:persistenStorePath error:nil];
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistenStorePath options:nil error:&error]) {
                NSLog(@"Unresolved Error: %@, %@", error, error.userInfo);
                abort();
            }
        }
    }
    return _persistentStoreCoordinator;
}

-(void)managedObjectContextDidSave:(NSNotification *)notification {
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

-(NSString *)nameForEntity:(EkkoEntityType)entity {
    return (NSString *)EkkoEntityTypes[entity];
}

-(NSEntityDescription *)entityDescriptionForEntity:(EkkoEntityType)entity {
    return (NSEntityDescription *)[[self.managedObjectModel entitiesByName] objectForKey:[self nameForEntity:entity]];
}

-(NSManagedObject *)insertNewObjectForEntity:(EkkoEntityType)entity inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [NSEntityDescription insertNewObjectForEntityForName:[self nameForEntity:entity] inManagedObjectContext:managedObjectContext];
}

-(NSFetchRequest *)fetchRequestForEntity:(EkkoEntityType)entity {
    return [NSFetchRequest fetchRequestWithEntityName:[self nameForEntity:entity]];
}

-(BOOL)saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSError *error = nil;
    BOOL result = [managedObjectContext save:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    return result;
}

@end
