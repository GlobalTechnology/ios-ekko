//
//  ProgressManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ProgressManager.h"
#import "CoreDataService.h"

@interface ProgressManager ()

@property (nonatomic, strong, readonly) NSMapTable *delegateMap;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

//@property (nonatomic, strong, readonly) NSCache *progressIdCache;

@end

@implementation ProgressManager

@synthesize delegateMap = _delegateMap;
@synthesize managedObjectContext = _managedObjectContext;

+(ProgressManager *)progressManager {
    __strong static ProgressManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[ProgressManager alloc] init];
    });
    return _manager;
}

-(NSMapTable *)delegateMap {
    if (_delegateMap == nil) {
        _delegateMap = [NSMapTable weakToWeakObjectsMapTable];
    }
    return _delegateMap;
}

-(NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [[CoreDataService sharedService] persistentStoreCoordinator];
        if(coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

+(void)setItemComplete:(NSString *)itemId forCourse:(NSString *)courseId {
    [[ProgressManager progressManager] setItemComplete:itemId forCourse:courseId];
}

-(void)addProgressDelegate:(id<ProgressManagerDelegate>)delegate forDataSource:(id<ProgressManagerDataSource>)dataSource {
    [self.delegateMap setObject:dataSource forKey:delegate];
    [self notifyDelgatesOfProgress:[dataSource courseId]];
}

-(void)removeProgressDelegate:(id<ProgressManagerDelegate>)delegate {
    [self.delegateMap removeObjectForKey:delegate];
}

-(void)removeProgressDelegate:(id<ProgressManagerDelegate>)delegate andDataSource:(id<ProgressManagerDataSource>)dataSource {
    id<ProgressManagerDataSource> currentDataSource = [self.delegateMap objectForKey:delegate];
    if (currentDataSource && currentDataSource == dataSource) {
        [self.delegateMap removeObjectForKey:delegate];
    }
}

#pragma mark - private
-(void)notifyDelgatesOfProgress:(NSString *)courseId {
    for (id<ProgressManagerDelegate> delegate in self.delegateMap) {
        id<ProgressManagerDataSource> dataSource = [self.delegateMap objectForKey:delegate];
        if ([courseId isEqualToString:[dataSource courseId]]) {
            [self progressOf:dataSource progressBlock:^(float progress) {
                if (delegate && [delegate respondsToSelector:@selector(progressUpdateFor:currentProgress:)]) {
                    [delegate progressUpdateFor:dataSource currentProgress:progress];
                }
            }];
        }
    }
}

-(void)setItemComplete:(NSString *)itemId forCourse:(NSString *)courseId {
    [self.managedObjectContext performBlock:^{
        ProgressItem *progressItem = (ProgressItem *)[NSEntityDescription insertNewObjectForEntityForName:[[CoreDataService sharedService] nameForEntityType:EkkoCoreDataEntityProgressItem] inManagedObjectContext:self.managedObjectContext];
        NSFetchRequest *request = [[CoreDataService sharedService] fetchRequestForEntity:EkkoCoreDataEntityProgressItem];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"courseId == %@ AND itemId == %@", courseId, itemId];
        [request setPredicate:predicate];
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
        if (results && [results count] == 0) {
            progressItem.courseId = courseId;
            progressItem.itemId = itemId;
            [self.managedObjectContext save:nil];
            [self notifyDelgatesOfProgress:courseId];
        }
    }];
}

-(void)progressOf:(id<ProgressManagerDataSource>)dataSource progressBlock:(void (^)(float))progressBlock {
    NSSet *progressItemIds = [dataSource progressItemIds];
    float total = [[NSNumber numberWithUnsignedInteger:[progressItemIds count]] floatValue];
    if (total > 0.f) {
        NSFetchRequest *request = [[CoreDataService sharedService] fetchRequestForEntity:EkkoCoreDataEntityProgressItem];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"courseId == %@", [dataSource courseId]], [NSPredicate predicateWithFormat:@"itemId IN %@", progressItemIds]]];
        [request setPredicate:predicate];
        
        [self.managedObjectContext performBlock:^{
            NSArray *results = [self.managedObjectContext executeFetchRequest:request error:nil];
            if (results && [results count] > 0) {
                float count = [[NSNumber numberWithUnsignedInteger:[results count]] floatValue];
                progressBlock(count/total);
            }
            else {
                progressBlock(0.f);
            }
        }];
    }
    else {
        progressBlock(0.f);
    }
}

@end
