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

@interface ManifestManager () {
    NSCache *_manifestCache;
}
@end

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
    if (self != nil) {
        _manifestCache = [[NSCache alloc] init];
        [_manifestCache setName:kManifestManagerCacheName];
    }
    return self;
}

-(void)getManifest:(NSString *)courseId completeBlock:(void(^)(Manifest *manifest))complete {
    [self getManifest:courseId withOptions:0 completeBlock:^(Manifest *manifest) {
        complete(manifest);
    }];
}

-(void)getManifest:(NSString *)courseId withOptions:(ManifestManagerOptions)options completeBlock:(void(^)(Manifest *manifest))complete {
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

-(NSString *)pathForManifest:(NSString *)courseId {
    return [[[ResourceManager sharedManager] pathForCourseId:courseId] stringByAppendingPathComponent:kManifestManagerFilename];
}




-(Manifest *)getManifestByCourseId:(NSString *)courseId {
    return nil;
}

-(BOOL)hasManifestWithCourseId:(NSString *)courseId {
    return NO;
}

-(void)syncManifest:(NSString *)courseId complete:(void (^)())complete {

}

@end
