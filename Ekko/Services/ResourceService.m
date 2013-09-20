//
//  ResourceService.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/16/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceService.h"
#import "ResourceCache.h"
#import "HubClient.h"

#import "NSString+MD5.h"

/*
@interface ResourceKey : NSObject<NSCopying>
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *sha1;
@property (nonatomic, copy) NSString *uri;
@property (nonatomic) EkkoResourceProvider provider;
@end

@implementation ResourceKey

-(id)initWithResource:(Resource *)resource {
    self = [super init];
    if (self) {
        self.courseId = resource.courseId;
        self.sha1 = resource.sha1 ?: nil;
        self.uri = resource.uri ?: nil;;
        self.provider = resource.provider;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    ResourceKey *key = [[ResourceKey allocWithZone:zone] init];
    [key setCourseId:self.courseId];
    [key setSha1:self.sha1];
    [key setUri:self.uri];
    [key setProvider:self.provider];
    return key;
}

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([object isKindOfClass:[self class]]) {
        ResourceKey *key = (ResourceKey *)object;
        return [self.courseId isEqual:key.courseId]
            && ((self.sha1 == nil && key.sha1 == nil) || (self.sha1 != nil && [self.sha1 isEqual:key.sha1]))
            && ((self.uri == nil && key.uri == nil) || (self.uri != nil && [self.uri isEqual:key.uri]))
            && self.provider == key.provider;
    }
    return NO;
}

-(NSUInteger)hash {
    NSUInteger hash = 1;
    hash = 31 * hash + [self.courseId hash];
    hash = 31 * hash + (self.sha1 != nil ? [self.sha1 hash] : 0);
    hash = 31 * hash + (self.uri != nil ? [self.uri hash] : 0);
    hash = 31 * hash + self.provider;
    return hash;
}
@end
*/

@interface ResourceService ()
@property (nonatomic, strong) NSMutableDictionary *courseCaches;
@end

@implementation ResourceService

+(ResourceService *)sharedService {
    __strong static ResourceService *_service = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _service = [[ResourceService alloc] init];
        _service.courseCaches = [NSMutableDictionary dictionary];
    });
    return _service;
}

-(ResourceCache *)cacheForCourseId:(NSString *)courseId {
    ResourceCache *cache = nil;
    cache = [self.courseCaches objectForKey:courseId];
    if (cache == nil) {
        cache = [[ResourceCache alloc] initWithCourseId:courseId];
        [self.courseCaches setObject:cache forKey:courseId];
    }
    return cache;
}

-(BOOL)isValidFileResource:(Resource *)resource {
    return resource && [resource isFile] && resource.sha1;
}

-(BOOL)isDownloadableUriResource:(Resource *)resource {
    return resource && [resource isUri] && resource.provider == EkkoResourceProviderNone;
}

-(void)getFileResource:(Resource *)resource delegate:(id<ResourceServiceImageDelegate>)delegate {
    if (![self isValidFileResource:resource]) {
        return;
    }
    NSString *key = [resource.sha1 copy];
    ResourceCache *cache = [self cacheForCourseId:resource.courseId];
    
    [cache objectForKey:key withCallback:^(id object) {
        if (object) {
            UIImage *image = [UIImage imageWithData:object scale:[UIScreen mainScreen].scale];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate resourceService:resource image:image];
            });
        }
        else {
            [[HubClient sharedClient] getCourseResource:resource.courseId sha1:resource.sha1 completionHandler:^(NSData *data) {
                UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate resourceService:resource image:image];
                });
                
                [cache setObject:UIImagePNGRepresentation(image) forKey:key];
            }];
        }
    }];
}

-(void)getUriResource:(Resource *)resource delegate:(id<ResourceServiceImageDelegate>)delegate {
    if (![self isDownloadableUriResource:resource]) {
        return;
    }
}

-(void)getResource:(Resource *)resource delegate:(id<ResourceServiceImageDelegate>)delegate {
    if ([self isValidFileResource:resource] && resource.sha1) {
        [self getFileResource:resource delegate:delegate];
    }
    else if ([self isDownloadableUriResource:resource] && resource.uri) {
        [self getUriResource:resource delegate:delegate];
    }
}

@end
