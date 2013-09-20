//
//  ResourceCache.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/19/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceCache.h"

@interface ResourceCache ()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *cacheDirectory;
-(NSCache *)sharedCache;
-(dispatch_queue_t)sharedDispatchQueue;
-(NSString *)_cacheKeyforKey:(NSString *)key;
@end

@implementation ResourceCache

@synthesize courseId = _courseId;

-(id)init {
    return nil;
}

-(id)initWithCourseId:(NSString *)courseId {
    self = [super init];
    if (self) {
        _courseId = [courseId copy];
        self.fileManager = [[NSFileManager alloc] init];
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.cacheDirectory = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"org.ekkoproject.ios.player/%@", courseId]];
        
        if(![self.fileManager fileExistsAtPath:self.cacheDirectory]) {
            [self.fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

-(NSString *)pathForKey:(NSString *)key {
    return [self.cacheDirectory stringByAppendingPathComponent:key];
}


-(void)objectForKey:(NSString *)key withCallback:(void (^)(id))callback {
    dispatch_async(self.sharedDispatchQueue, ^{
        id object = [self.sharedCache objectForKey:[self _cacheKeyforKey:key]];
        if (!object) {
            object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForKey:key]];
            if (object) {
                [self.sharedCache setObject:object forKey:[self _cacheKeyforKey:key]];
            }
        }
        callback(object);
    });
}

-(BOOL)objectExistsForKey:(NSString *)key {
    BOOL exists = ([self.sharedCache objectForKey:[self _cacheKeyforKey:key]] != nil);
    if (exists) {
        return YES;
    }
    return [self.fileManager fileExistsAtPath:[self pathForKey:key]];
}

-(void)setObject:(id)object forKey:(NSString *)key {
    if (!object) {
        return;
    }
    dispatch_async(self.sharedDispatchQueue, ^{
        if ([self objectExistsForKey:key]) {
            return;
        }
        [self.sharedCache setObject:object forKey:[self _cacheKeyforKey:key]];
        [NSKeyedArchiver archiveRootObject:object toFile:[self pathForKey:key]];
    });
}

-(void)removeObjectForKey:(NSString *)key {
    [self.sharedCache removeObjectForKey:[self _cacheKeyforKey:key]];
    dispatch_async(self.sharedDispatchQueue, ^{
        [self.fileManager removeItemAtPath:[self pathForKey:key] error:nil];
    });
}

-(void)removeAllObjects {
    [self.sharedCache removeAllObjects];
    dispatch_async(self.sharedDispatchQueue, ^{
        for (NSString *path in [self.fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:nil]) {
            [self.fileManager removeItemAtPath:[self.cacheDirectory stringByAppendingPathComponent:path] error:nil];
        }
    });
}

-(NSString *)_cacheKeyforKey:(NSString *)key {
    return [self.courseId stringByAppendingFormat:@"-%@", key];
}

-(NSCache *)sharedCache {
    __strong static NSCache *_cache = nil;
    static dispatch_once_t _cache_once_t;
    dispatch_once(&_cache_once_t, ^{
        _cache = [[NSCache alloc] init];
        [_cache setName:@"org.ekkoproject.ios.player.resourcecache"];
    });
    return _cache;
}

-(dispatch_queue_t)sharedDispatchQueue {
    static dispatch_queue_t _dispatch_queue = nil;
    static dispatch_once_t _dispatch_once_t;
    dispatch_once(&_dispatch_once_t, ^{
        _dispatch_queue = dispatch_queue_create("org.ekkoproject.ios.player.resourcecache", DISPATCH_QUEUE_CONCURRENT);
    });
    return _dispatch_queue;
}

@end
