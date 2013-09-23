//
//  ResourceService.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/16/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceService.h"
#import "ResourceImageCache.h"
#import "HubClient.h"

#import "NSString+MD5.h"
#import "UIImage+Ekko.h"
#import <AFImageRequestOperation.h>

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

-(ResourceImageCache *)cacheForCourseId:(NSString *)courseId {
    ResourceImageCache *cache = nil;
    cache = [self.courseCaches objectForKey:courseId];
    if (cache == nil) {
        cache = [[ResourceImageCache alloc] initWithCourseId:courseId];
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
    ResourceImageCache *cache = [self cacheForCourseId:resource.courseId];

    [cache imageForKey:key withCallback:^(UIImage *image) {
        if (image) {
            if (delegate) {
                [delegate resourceService:resource image:image];
            }
        }
        else {
            [[HubClient sharedClient] getCourseResource:resource.courseId sha1:resource.sha1 completionHandler:^(NSData *data) {
                UIImage *image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
                if (delegate) {
                    [delegate resourceService:resource image:image];
                }
                [cache setImage:image forKey:key];
            }];
        }
    }];
}

-(void)getUriResource:(Resource *)resource delegate:(__weak id<ResourceServiceImageDelegate>)delegate {
    if (![self isDownloadableUriResource:resource]) {
        return;
    }
    NSString *key = [resource.uri MD5];
    ResourceImageCache *cache = [self cacheForCourseId:resource.courseId];
    
    [cache imageForKey:key withCallback:^(UIImage *image) {
        if (image) {
            if (delegate) {
                [delegate resourceService:resource image:image];
            }
        }
        else {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resource.uri] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            [[AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
                if (image) {
                    if (delegate) {
                        [delegate resourceService:resource image:image];
                    }
                    [cache setImage:image forKey:key];
                }
            }] start];
        }
    }];
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
