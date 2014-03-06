//
//  ResourceManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/25/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceManager.h"

#import "EkkoCloudClient.h"
#import "ArclightClient.h"
#import "HTTPClient.h"

#import "CoreDataManager.h"
#import <AFHTTPRequestOperation.h>
#import <TheKeyOAuth2Client.h>

#import "UIImage+Ekko.h"

NSString *const kEkkoResourceManagerImageCache = @"org.ekkoproject.ios.player.imagecache";
NSString *const kEkkoResourceManagerCacheDirectoryName = @"org.ekkoproject.ios.player";

@interface ResourceManager ()
@property (nonatomic, strong) NSString *cacheDirectory;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) NSMutableDictionary *imageDelegates;
@end

@implementation ResourceManager

+(ResourceManager *)sharedManager {
    __strong static ResourceManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[ResourceManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
        [self.imageCache setName:kEkkoResourceManagerImageCache];
        
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.cacheDirectory = [cachesDirectory stringByAppendingPathComponent:kEkkoResourceManagerCacheDirectoryName];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.cacheDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }

        self.imageDelegates = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)getImage:(Resource *)resource imageDelegate:(id<ResourceManagerImageDelegate>)delegate {
    NSString *cacheKey = [self cacheKeyForResource:resource];
    NSString *path = [self pathForResource:resource];

    //Check to see if image is already loading
    @synchronized(self.imageDelegates) {
        NSPointerArray *delegates = (NSPointerArray *)[self.imageDelegates objectForKey:cacheKey];
        if (delegates == nil) {
            delegates = [NSPointerArray weakObjectsPointerArray];
            [delegates addPointer:(__bridge void *)(delegate)];
            [self.imageDelegates setObject:delegates forKey:cacheKey];
        }
        else {
            [delegates addPointer:(__bridge void *)(delegate)];
            return;
        }
    }

    //Try to load image from cache
    UIImage *image = (UIImage *)[self.imageCache objectForKey:cacheKey];
    if (image) {
        [self processImageDelegates:image forResource:resource];
        return;
    }

    //Load image from disk and cache if it exists
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (data) {
        image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
        if (image) {
            [self processImageDelegates:image forResource:resource];
            [self.imageCache setObject:image forKey:cacheKey];
            return;
        }
    }

    //Download image if not in cache or disk
    if (resource.type == EkkoResourceTypeFile) {
        [[EkkoCloudClient sharedClient] getResource:resource.courseId sha1:resource.sha1 completeBlock:^(NSData *data) {
            UIImage *image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
            if (image) {
                [self processImageDelegates:image forResource:resource];
                [self.imageCache setObject:image forKey:cacheKey];
                [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
            }
        }];
    }
    else if (resource.type == EkkoResourceTypeURI) {
        AFHTTPRequestOperation *operation = [[HTTPClient sharedClient] GET:resource.uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                UIImage *image = (UIImage *)responseObject;
                [self processImageDelegates:image forResource:resource];
                [self.imageCache setObject:image forKey:cacheKey];
                [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
    }
    else if (resource.type == EkkoResourceTypeECV) {
        [[EkkoCloudClient sharedClient] getVideoThumbnailURL:resource.courseId videoId:resource.videoId completeBlock:^(NSURL *videoThumbnailUrl) {
            AFHTTPRequestOperation *operation = [[HTTPClient sharedClient] GET:[videoThumbnailUrl absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                    UIImage *image = (UIImage *)responseObject;
                    [self processImageDelegates:image forResource:resource];
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
        }];
    }
    else if (resource.type == EkkoResourceTypeArclight) {
        [[ArclightClient sharedClient] getThumbnailURL:resource.refId complete:^(NSURL *thumbnailURL) {
            AFHTTPRequestOperation *operation = [[HTTPClient sharedClient] GET:[thumbnailURL absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                    UIImage *image = (UIImage *)responseObject;
                    [self processImageDelegates:image forResource:resource];
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
        }];
    }
}

-(void)processImageDelegates:(UIImage *)image forResource:(Resource *)resource {
    NSString *key = [self cacheKeyForResource:resource];

    NSPointerArray *delegates = nil;
    @synchronized(self.imageDelegates) {
        delegates = [self.imageDelegates objectForKey:key];
        [self.imageDelegates removeObjectForKey:key];
    }

    if (delegates) {
        for (id<ResourceManagerImageDelegate> delegate in delegates) {
            if (delegate) {
                [delegate image:image forResource:resource];
            }
        }
    }
    delegates = nil;
}






























-(void)getResource:(Resource *)resource progressBlock:(void (^)(Resource *, float))progressBlock completeBlock:(void (^)(Resource *, NSString *))completeBlock {
    if (resource.type == EkkoResourceTypeFile) {
        NSString *path = [self pathForResource:resource];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            completeBlock(resource, [path copy]);
        }
        else {
            [[EkkoCloudClient sharedClient] getResource:resource.courseId sha1:resource.sha1 outputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO] progressBlock:^(float progress) {
                progressBlock(resource, progress);
            } completeBlock:^{
                completeBlock(resource, path);
            }];
        }
    }
    else if (resource.type == EkkoResourceTypeECV) {
    }
}

-(void)getResource:(Resource *)resource delegate:(__weak id<ResourceManagerDelegate>)delegate {
    [self getResource:resource progressBlock:^(Resource *resource, float progress) {
        if (delegate && [delegate respondsToSelector:@selector(resource:progress:)]) {
            [delegate resource:resource progress:progress];
        }
    } completeBlock:^(Resource *resource, NSString *path) {
        if (delegate && [delegate respondsToSelector:@selector(resource:complete:)]) {
            [delegate resource:resource complete:path];
        }
    }];
}

-(NSString *)pathForCourseId:(NSString *)courseId {
    NSString *courseDirectory = [self.cacheDirectory stringByAppendingPathComponent:courseId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:courseDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:courseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return courseDirectory;
}

-(NSString *)pathForResource:(Resource *)resource {
    NSString *courseDirectory = [self pathForCourseId:resource.courseId];
    NSString *filename = [resource filenameOnDisk];
    if (filename) {
        return [courseDirectory stringByAppendingPathComponent:filename];
    }
    return nil;
}

-(NSString *)cacheKeyForResource:(Resource *)resource {
    return [resource.courseId stringByAppendingFormat:@"-%@", [resource filenameOnDisk]];
}

@end
