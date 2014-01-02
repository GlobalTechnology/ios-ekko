//
//  ResourceManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/25/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceManager.h"
#import "CourseIdProtocol.h"
#import "HubClient.h"
#import <AFHTTPRequestOperation.h>

#import "UIImage+Ekko.h"

NSString *const kEkkoResourceManagerImageCache = @"org.ekkoproject.ios.player.imagecache";
const char * kEkkoResourceManagerDispatchQueue = "org.ekkoproject.ios.player.resourcemanager.queue";
NSString *const kEkkoResourceManagerCacheDirectoryName = @"org.ekkoproject.ios.player";

@interface ResourceManager ()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *cacheDirectory;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong, readonly) dispatch_queue_t dispatchQueue;
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
        
        self.fileManager = [[NSFileManager alloc] init];
        NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        self.cacheDirectory = [cachesDirectory stringByAppendingPathComponent:kEkkoResourceManagerCacheDirectoryName];
        
        if(![self.fileManager fileExistsAtPath:self.cacheDirectory]) {
            [self.fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

-(void)getImageResource:(Resource *)resource completeBlock:(void (^)(Resource *, UIImage *))completeBlock {
    dispatch_async(self.dispatchQueue, ^{
        NSString *cacheKey = [self cacheKeyForResource:resource];

        //Try to load image from cache
        UIImage *image = (UIImage *)[self.imageCache objectForKey:cacheKey];
        if (image) {
            completeBlock(resource, image);
            return;
        }
        
        //Load image from disk and cache if it exists
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForResource:resource]];
        if (data) {
            image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
            if (image) {
                completeBlock(resource, image);
                [self.imageCache setObject:image forKey:cacheKey];
                return;
            }
        }
        
        //Download image if not in cache or disk
        if ([resource isFile]) {
            [[HubClient sharedClient] getResource:resource.courseId sha1:resource.sha1 callback:^(NSData *data) {
                UIImage *image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
                if (image) {
                    completeBlock(resource, image);
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:[self pathForResource:resource]];
                }
            }];
        }
        else if ([resource isUri]) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:resource.uri] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            AFHTTPRequestOperation * operation = [[HubClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                    UIImage *image = (UIImage *)responseObject;
                    completeBlock(resource, image);
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:[self pathForResource:resource]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
            [operation start];
        }
    });
}

-(void)getResource:(Resource *)resource progressBlock:(void (^)(Resource *, float))progressBlock completeBlock:(void (^)(Resource *, NSString *))completeBlock {
    dispatch_async(self.dispatchQueue, ^{
        NSString *path = [self pathForResource:resource];
        if ([self.fileManager fileExistsAtPath:path]) {
            completeBlock(resource, [path copy]);
            return;
        }
        
        if ([resource isFile]) {
            NSOutputStream *outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
            [[HubClient sharedClient] getResource:resource.courseId sha1:resource.sha1 outputStream:outputStream progress:^(float progress) {
                progressBlock(resource, progress);
            } complete:^{
                completeBlock(resource, path);
            }];
        }
    });
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
    if (![self.fileManager fileExistsAtPath:courseDirectory]) {
        [self.fileManager createDirectoryAtPath:courseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
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

-(dispatch_queue_t)dispatchQueue {
    static dispatch_queue_t _dispatch_queue = nil;
    static dispatch_once_t _dispatch_once_t;
    dispatch_once(&_dispatch_once_t, ^{
        _dispatch_queue = dispatch_queue_create(kEkkoResourceManagerDispatchQueue , DISPATCH_QUEUE_CONCURRENT);
    });
    return _dispatch_queue;
}

@end
