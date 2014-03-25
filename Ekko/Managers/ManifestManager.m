//
//  ManifestManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ManifestManager.h"

#import "EkkoCloudClient.h"
#import "ResourceManager.h"

#import "ManifestXMLParser.h"

static NSString *const kManifestManagerCacheName = @"ManifestManagerCache";
static NSString *const kManifestManagerFilename  = @"manifest.xml";

NSString *const EkkoManifestManagerDidSyncManifestNotification = @"EkkoManifestManagerDidSyncManifestNotification";

typedef void (^manifestBlock) (Manifest *manifest);

@interface ManifestManager () {
    NSCache *_manifestCache;
}
@end

@implementation ManifestManager

+(ManifestManager *)manifestManager {
    __strong static ManifestManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[ManifestManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        _manifestCache = [[NSCache alloc] init];
        [_manifestCache setName:kManifestManagerCacheName];
    }
    return self;
}

-(void)getManifest:(NSString *)courseId withOptions:(ManifestManagerOptions)options completeBlock:(manifestBlock)complete {
    Manifest *manifest = nil;

    if((options & ManifestSkipCache) != ManifestSkipCache) {
        // Load manifest from cache
        manifest = (Manifest *)[_manifestCache objectForKey:courseId];
        if(manifest) {
            complete(manifest);
            return;
        }
    }

    NSString *path = [self pathForManifest:courseId];
    if((options & ManifestSkipFile) != ManifestSkipFile) {
        // Read manifest from disk
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSInputStream *manifestStream = [[NSInputStream alloc] initWithFileAtPath:path];
            // Parse manifest
            ManifestXMLParser *parser = [[ManifestXMLParser alloc] initWithStream:manifestStream];
            [parser parse];
            manifest = parser.manifest;
            if (manifest) {
                [_manifestCache setObject:manifest forKey:courseId];
                complete(manifest);
                return;
            }
        }
    }

    if((options & ManifestSkipDownload) != ManifestSkipDownload) {
        // Download manifest from Ekko Cloud
        [[EkkoCloudClient sharedClient] getManifest:courseId completeBlock:^(NSData *manifestData, NSError *error) {
            if (manifestData) {
                // Parse manifest
                ManifestXMLParser *parser = [[ManifestXMLParser alloc] initWithData:manifestData];
                [parser parse];
                Manifest *manifest = parser.manifest;
                if (manifest) {
                    [_manifestCache setObject:manifest forKey:courseId];
                    [[NSFileManager defaultManager] createFileAtPath:path contents:manifestData attributes:nil];
                    complete(manifest);
                }
            }
            else {
                complete(nil);
            }
        }];
        return;
    }
    complete(nil);
}

-(void)syncManifest:(NSString *)courseId completeBlock:(manifestBlock)complete {
    [self getManifest:courseId withOptions:ManifestSkipCache|ManifestSkipFile completeBlock:^(Manifest *manifest) {
        if (manifest == nil) {
            return;
        }
        complete(manifest);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:EkkoManifestManagerDidSyncManifestNotification object:self userInfo:@{@"manifest": manifest}];
        });
    }];
}

#pragma mark - Private

-(NSString *)pathForManifest:(NSString *)courseId {
    return [[[ResourceManager resourceManager] pathForCourse:courseId] stringByAppendingPathComponent:kManifestManagerFilename];
}

@end
