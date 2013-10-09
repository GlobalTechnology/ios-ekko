//
//  ProgressManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ProgressManager.h"
#import "DataManager.h"
#import "ProgressItem.h"

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
        _managedObjectContext = [[DataManager dataManager] newPrivateQueueManagedObjectContext];
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
        NSFetchRequest *request = [[DataManager dataManager] fetchRequestForEntity:EkkoProgressItemEntity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@ AND itemId == %@", courseId, itemId]];
        NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:nil];
        if (count == 0) {
            ProgressItem *progressItem = (ProgressItem *)[[DataManager dataManager] insertNewObjectForEntity:EkkoProgressItemEntity inManagedObjectContext:self.managedObjectContext];
            progressItem.courseId = courseId;
            progressItem.itemId = itemId;
            [[DataManager dataManager] saveManagedObjectContext:self.managedObjectContext];
            [self notifyDelgatesOfProgress:courseId];
        }
    }];
}

-(void)progressOf:(id<ProgressManagerDataSource>)dataSource progressBlock:(void (^)(float))progressBlock {
    NSSet *progressItemIds = [dataSource progressItemIds];
    float total = [[NSNumber numberWithUnsignedInteger:[progressItemIds count]] floatValue];
    if (total > 0.f) {
        NSFetchRequest *request = [[DataManager dataManager] fetchRequestForEntity:EkkoProgressItemEntity];
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
