//
//  ResourceManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/25/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ResourceManager.h"
#import "DataManager.h"
#import "CourseIdProtocol.h"
#import "HubClient.h"
#import <AFHTTPRequestOperation.h>

#import "UIImage+Ekko.h"

NSString *const kEkkoResourceManagerImageCache = @"org.ekkoproject.ios.player.imagecache";
NSString *const kEkkoResourceManagerCacheDirectoryName = @"org.ekkoproject.ios.player";

@interface ResourceManager ()
@property (nonatomic, strong) NSString *cacheDirectory;
@property (nonatomic, strong) NSCache *imageCache;
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
    }
    return self;
}

-(void)getImageResource:(NSString *)resourceId
               courseId:(NSString *)courseId
                   sha1:(NSString *)sha1
          completeBlock:(void (^)(NSString *courseId, NSString *resourceId, UIImage *))completeBlock {
}


-(void)getImageResource:(Resource *)resource completeBlock:(void (^)(Resource *, UIImage *))completeBlock {
    NSManagedObjectContext *privateContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [privateContext performBlock:^{
        NSError *error;
        Resource *_resource = (Resource *)[privateContext existingObjectWithID:resource.objectID error:&error];
        if (error) {
            return;
        }
        NSString *cacheKey = [self cacheKeyForResource:_resource];
        NSString *path = [self pathForResource:_resource];

        //Try to load image from cache
        UIImage *image = (UIImage *)[self.imageCache objectForKey:cacheKey];
        if (image) {
            completeBlock(resource, image);
            return;
        }

        //Load image from disk and cache if it exists
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (data) {
            image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
            if (image) {
                completeBlock(resource, image);
                [self.imageCache setObject:image forKey:cacheKey];
                return;
            }
        }

        //Download image if not in cache or disk
        if ([_resource isFile]) {
            [[HubClient sharedClient] getResource:_resource.courseId sha1:resource.sha1 callback:^(NSData *data) {
                UIImage *image = [UIImage inflatedImage:data scale:[UIScreen mainScreen].scale];
                if (image) {
                    completeBlock(resource, image);
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
                }
            }];
        }
        else if ([_resource isUri]) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_resource.uri] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
            AFHTTPRequestOperation * operation = [[HubClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                    UIImage *image = (UIImage *)responseObject;
                    completeBlock(resource, image);
                    [self.imageCache setObject:image forKey:cacheKey];
                    [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
            [operation start];
        }
        else if ([_resource isEkkoCloudVideo]) {
            [[HubClient sharedClient] getECVResourceURL:_resource.courseId videoId:_resource.videoId urlType:EkkoCloudVideoURLTypeThumbnail complete:^(NSURL *videoURL) {
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
                AFHTTPRequestOperation *operation = [[HubClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (responseObject && [responseObject isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *)responseObject;
                        completeBlock(resource, image);
                        [self.imageCache setObject:image forKey:cacheKey];
                        [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:path];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                }];
                [operation setResponseSerializer:[AFImageResponseSerializer serializer]];
                [operation start];
            }];
        }

    }];
}

-(void)getResource:(Resource *)resource progressBlock:(void (^)(Resource *, float))progressBlock completeBlock:(void (^)(Resource *, NSString *))completeBlock {
    NSManagedObjectContext *privateContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [privateContext performBlock:^{
        NSError *error;
        Resource *_resource = (Resource *)[privateContext existingObjectWithID:resource.objectID error:&error];
        if (error) {
            return;
        }
        if ([_resource isFile]) {
            NSString *path = [self pathForResource:_resource];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                completeBlock(resource, [path copy]);
            }
            else {
                [[HubClient sharedClient] getResource:_resource.courseId sha1:_resource.sha1 outputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO] progress:^(float progress) {
                    progressBlock(resource, progress);
                } complete:^{
                    completeBlock(resource, path);
                }];
            }
        }
        else if ([_resource isEkkoCloudVideo]) {
            [[HubClient sharedClient] getECVResourceURL:_resource.courseId videoId:_resource.videoId urlType:EkkoCloudVideoURLTypeDownload complete:^(NSURL *videoURL) {
                [privateContext performBlock:^{
                    NSString *path = [[self pathForResource:_resource] stringByAppendingPathExtension:[videoURL pathExtension]];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        completeBlock(resource, [path copy]);
                    }
                    else {
                        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:videoURL];
                        AFHTTPRequestOperation *operation = [[HubClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            completeBlock(resource, path);
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                        }];
                        [operation setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:path append:NO]];
                        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                            float progress = totalBytesRead / (float)totalBytesExpectedToRead;
                            progressBlock(resource, progress);
                        }];
                        [operation start];
                    }
                }];
            }];
        }
    }];
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
