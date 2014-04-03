//
//  ProgressManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 3/19/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ProgressManager.h"
#import <TheKeyOAuth2Client.h>
#import "CoreDataManager.h"
#import "ManifestManager.h"

#import "ProgressItem.h"
#import "Answer.h"

#import "Manifest+Progress.h"
#import "Lesson+Progress.h"

NSString *const EkkoProgressManagerDidUpdateProgressNotification = @"EkkoProgressManagerDidUpdateProgressNotification";
typedef void (^progressBlock) (Progress *progress);

@interface Progress ()
-(void) addProgress:(Progress *)progress;
@end

@interface ProgressManager ()
@property (nonatomic, strong, readwrite) NSString *guid;
@property (nonatomic, strong) NSCache *progress;
@property (nonatomic, strong) NSMutableDictionary *locks;
@end

@implementation ProgressManager

+(ProgressManager *)progressManagerForGUID:(NSString *)guid {
    __strong static NSMutableDictionary *_managers = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _managers = [NSMutableDictionary dictionary];
    });

    ProgressManager *manager = nil;
    @synchronized(_managers) {
        guid = guid ?: [[TheKeyOAuth2Client sharedOAuth2Client] guid];
        manager = (ProgressManager *)[_managers objectForKey:guid];
        if(manager == nil) {
            manager = [[ProgressManager alloc] initWithGUID:guid];
            [_managers setObject:manager forKey:guid];
        }
    }
    return manager;
}

+(ProgressManager *)progressManager {
    return [ProgressManager progressManagerForGUID:nil];
}

-(id)initWithGUID:(NSString *)guid {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.guid = guid;
    self.progress = [[NSCache alloc] init];
    self.locks = [NSMutableDictionary dictionary];
    return self;
}

-(void)progressForCourse:(Manifest *)manifest progress:(progressBlock)progressBlock {
    NSMutableSet *currentItems = [self getCourseProgressItems:manifest.courseId];
    NSMutableSet *allItems = [manifest progressItems];

    Progress *progress = [[Progress alloc] init];
    progress.total = [allItems count];
    [allItems intersectSet:currentItems];
    progress.complete = [allItems count];

    dispatch_async(dispatch_get_main_queue(), ^{
        progressBlock(progress);
    });
}

-(void)progressForCourseId:(NSString *)courseId progress:(progressBlock)progressBlock {
    [[ManifestManager manifestManager] getManifest:courseId withOptions:ManifestSkipDownload completeBlock:^(Manifest *manifest) {
        if (!manifest) {
            // Return empty progress for invalid manifest
            dispatch_async(dispatch_get_main_queue(), ^{
                progressBlock([[Progress alloc] init]);
            });
        }
        else {
            [self progressForCourse:manifest progress:progressBlock];
        }
    }];
}

-(void)progressForLesson:(Lesson *)lesson progress:(void (^)(Progress *))progressBlock {
    NSString *courseId = lesson.manifest.courseId;
    NSMutableSet *currentItems = [self getCourseProgressItems:courseId];
    NSMutableSet *lessonItems = [lesson progressItems];

    Progress *progress = [[Progress alloc] init];
    [progress setTotal:[lessonItems count]];
    [lessonItems intersectSet:currentItems];
    [progress setComplete:[lessonItems count]];

    dispatch_async(dispatch_get_main_queue(), ^{
        progressBlock(progress);
    });
}

-(void)recordProgress:(NSString *)contentId inCourse:(NSString *)courseId {
    NSManagedObjectContext *context = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
    [context performBlock:^{
        NSFetchRequest *request = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityProgressItem];
        [request setPredicate:[NSPredicate predicateWithFormat:@"guid = %@ AND courseId = %@ AND contentId = %@", self.guid, courseId, contentId]];
        NSError *error = nil;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        if (count == NSNotFound || count == 0) {
            ProgressItem *item = (ProgressItem *)[[CoreDataManager sharedManager] insertNewObjectForEntity:EkkoEntityProgressItem inManagedObjectContext:context];
            item.guid = self.guid;
            item.courseId = courseId;
            item.contentId = contentId;
            [[CoreDataManager sharedManager] saveManagedObjectContext:context];

            [self.progress removeObjectForKey:courseId];
            [self loadCourseProgressItems:courseId];
        }
    }];
}

-(NSMutableSet *)getCourseProgressItems:(NSString *)courseId {
    NSMutableSet *progressItems = [self.progress objectForKey:courseId];
    if (progressItems) {
        return progressItems;
    }
    return [self loadCourseProgressItems:courseId];
}

#pragma mark - Private

-(NSMutableSet *)loadCourseProgressItems:(NSString *)courseId {
    NSMutableSet __block *items = [NSMutableSet set];
    @synchronized([self getLock:courseId]) {
        NSMutableSet *cached = [self.progress objectForKey:courseId];
        if (cached) {
            return cached;
        }

        NSManagedObjectContext *context = [[CoreDataManager sharedManager] newPrivateQueueManagedObjectContext];
        [context performBlockAndWait:^{

            // Fetch ProgressItems
            NSFetchRequest *progressRequest = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityProgressItem];
            [progressRequest setPredicate:[NSPredicate predicateWithFormat:@"guid = %@ AND courseId = %@", self.guid, courseId]];
            NSError *error = nil;
            NSArray *progress = [context executeFetchRequest:progressRequest error:&error];
            if (progress && [progress count] > 0) {
                for (ProgressItem *item in progress) {
                    [items addObject:[item.contentId copy]];
                }
            }

            // Fetch Answers
            NSFetchRequest *answerRequest = [[CoreDataManager sharedManager] fetchRequestForEntity:EkkoEntityAnswer];
            [answerRequest setPredicate:[NSPredicate predicateWithFormat:@"guid = %@ AND courseId = %@", self.guid, courseId]];
            NSArray *answers = [context executeFetchRequest:answerRequest error:&error];
            if (answers && [answers count] > 0) {
                for (Answer *answer in answers) {
                    [items addObject:[answer.answer copy]];
                }
            }
        }];

        [self.progress setObject:items forKey:courseId];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:EkkoProgressManagerDidUpdateProgressNotification object:self userInfo:@{@"courseId": courseId}];
    });

    return items;
}

-(id)getLock:(NSString *)courseId {
    id lock;
    @synchronized(self.locks) {
        lock = [self.locks objectForKey:courseId];
        if (lock == nil) {
            lock = [NSObject new];
            [self.locks setObject:lock forKey:courseId];
        }
    }
    return lock;
}

@end

@implementation Progress

-(id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.complete = 0;
    self.total = 0;
    return self;
}

-(float)progress {
    if (self.total == 0) {
        return 0.f;
    }
    return self.complete / (float)self.total;
}

-(void)addProgress:(Progress *)progress {
    self.complete += progress.complete;
    self.total += progress.complete;
}

@end
