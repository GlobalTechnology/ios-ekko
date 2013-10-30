//
//  ManifestManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/29/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ManifestManager.h"

#import "HubClient.h"
#import "DataManager.h"

#import "Manifest+Hub.h"

@implementation ManifestManager

+(ManifestManager *)sharedManager {
    __strong static ManifestManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[ManifestManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)syncManifest:(NSString *)courseId {
    [self syncManifest:courseId complete:nil];
}

-(void)syncManifest:(NSString *)courseId complete:(void (^)())complete {
    [[HubClient sharedClient] getManifest:courseId callback:^(HubManifest *hubManifest) {
        NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
        [managedObjectContext performBlock:^{
            Manifest *manifest = [self getManifestByCourseId:courseId withManagedObjectContext:managedObjectContext];
            if (manifest == nil) {
                manifest = (Manifest *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityManifest inManagedObjectContext:managedObjectContext];
            }
            [manifest syncWithHubManifest:hubManifest];
            [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
            if (complete) {
                complete();
            }
        }];
    }];
}

-(BOOL)hasManifestWithCourseId:(NSString *)courseId {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityManifest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSUInteger count = [[[DataManager sharedManager] newPrivateQueueManagedObjectContext] countForFetchRequest:request error:nil];
    if (count > 0) {
        return YES;
    }
    return NO;
}

-(Manifest *)getManifestByCourseId:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityManifest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (results && results.count > 0) {
        return (Manifest *)[results firstObject];
    }
    return nil;
}

@end
