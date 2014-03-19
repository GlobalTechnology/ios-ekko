//
//  ArclightClient.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/24/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ArclightClient.h"

// Ekko Hub API URL key in Info.plist
static NSString *const kArclightAPIURL = @"ArclightAPIURL";
static NSString *const kArclightAPIKey = @"ArclightAPIKey";

static NSString *const kArclightParameterAPIKey        = @"apiKey";
static NSString *const kArclightParameterRefId         = @"refId";
static NSString *const kArclightParameterResponseType  = @"responseType";
static NSString *const kArclightParameterRequestPlayer = @"requestPlayer";

static NSString *const kArclightResponseTypeJSON = @"JSON";
static NSString *const kArclightRequestPlayerIOS = @"iOS";

static NSString *const kArclightEndpointGetAssetDetails = @"getAssetDetails";

@interface ArclightClient ()
@property (nonatomic, strong, readonly) NSArray *boxArtOrder;
@end

@interface ArclightRequestSerializer : AFHTTPRequestSerializer
@end

@implementation ArclightClient
@synthesize boxArtOrder = _boxArtOrder;

+(ArclightClient *)sharedClient {
    __strong static ArclightClient *_arclightClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _arclightClient = [[ArclightClient alloc] initWithBaseURL:[NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:kArclightAPIURL]]];
    });
    return _arclightClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [ArclightRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

-(NSArray *)boxArtOrder {
    if (_boxArtOrder == nil) {
        _boxArtOrder = @[
            @"Mobile cinematic high",
            @"HD",
            @"Large",
            @"Medium",
            @"Mobile cinematic low",
            @"Small"
        ];
    }
    return _boxArtOrder;
}

-(void)getThumbnailURL:(NSString *)refId complete:(void(^)(NSURL *thumbnailURL))complete {
    [self GET:kArclightEndpointGetAssetDetails parameters:@{kArclightParameterRefId: refId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Arclight has some messed up UTF-8 output, so if the responseObject is empty
        // but we have data, the JSON parser failed. Attempt to do it again with ASCII
        // encoding converted back to UTF-8
        // refId = refId=1_529-mld-0-0  My Last Day triggers this
        if (responseObject == nil && operation.responseData.length > 0) {
            NSString *data = [[NSString alloc] initWithData:operation.responseData encoding:NSASCIIStringEncoding];
            responseObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        }
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            // Use the videoStillUrl if it exists
            NSString *videoStillUrl = responseObject[@"assetDetails"][0][@"videoStillUrl"];
            if([videoStillUrl isKindOfClass:[NSString class]] && [videoStillUrl length] > 0) {
                complete([NSURL URLWithString:videoStillUrl]);
            }
            else {
                // Otherwise use boxArt in the order specified in the boxArtOrder NSArray
                NSArray *boxArtUrls = responseObject[@"assetDetails"][0][@"boxArtUrls"];
                if ([boxArtUrls isKindOfClass:[NSArray class]] && [boxArtUrls count] > 0) {
                    NSArray *sortedBoxArt = [boxArtUrls sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                        NSUInteger a_index = [self.boxArtOrder indexOfObject:a[@"url"][@"type"]];
                        NSUInteger b_index = [self.boxArtOrder indexOfObject:b[@"url"][@"type"]];
                        if (a_index == NSNotFound && b_index == NSNotFound)
                            return NSOrderedSame;
                        if (a_index == NSNotFound || b_index > a_index)
                            return NSOrderedAscending;
                        if (b_index == NSNotFound || a_index > b_index)
                            return NSOrderedDescending;
                        return NSOrderedSame;
                    }];
                    NSString *boxArtUri = [sortedBoxArt objectAtIndex:0][@"url"][@"uri"];
                    complete([NSURL URLWithString:boxArtUri]);
                }

            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)getVideoStreamUrl:(NSString *)refId complete:(void(^)(NSURL *videoStreamUrl))complete {
    [self GET:kArclightEndpointGetAssetDetails parameters:@{kArclightParameterRefId: refId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil && [operation.responseData length] > 0) {
            NSString *data = [[NSString alloc] initWithData:operation.responseData encoding:NSASCIIStringEncoding];
            responseObject = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        }
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *playerCode = responseObject[@"assetDetails"][0][@"playerCode"];
            if ([playerCode isKindOfClass:[NSString class]] && [playerCode length] > 0) {
                NSURL *videoUrl = [NSURL URLWithString:playerCode];
                complete(videoUrl);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

@end

@implementation ArclightRequestSerializer
-(NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
    NSMutableDictionary *params = [parameters mutableCopy];
    [params setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:kArclightAPIKey] forKey:kArclightParameterAPIKey];
    [params setObject:kArclightResponseTypeJSON forKey:kArclightParameterResponseType];
    [params setObject:kArclightRequestPlayerIOS forKey:kArclightParameterRequestPlayer];
    return [super requestWithMethod:method URLString:URLString parameters:params];
}
@end
