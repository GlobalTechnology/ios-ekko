//
//  HubClient.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubClient.h"
#import <TheKey.h>
#import <AFHTTPRequestOperation.h>
#import "CoursesParser.h"
#import "CourseParser.h"
#import "ManifestParser.h"
#import "URLUtils.h"

// Ekko Hub API URL key in Info.plist
static NSString *const kEkkoHubClientURL = @"EkkoHubURL";

// NSUserDefaults keys
static NSString *const kEkkoHubClientSessionId   = @"EkkoHubClientSessionId";
static NSString *const kEkkoHubClientSessionGuid = @"EkkoHubClientSessionGuid";

// Ekko Hub API Endpoints
static NSString *const kEkkoHubEndpointLogin    = @"auth/login";
static NSString *const kEkkoHubEndpointService  = @"auth/service";
static NSString *const kEkkoHubEndpointCourses  = @"courses";
static NSString *const kEkkoHubEndpointManifest = @"courses/course/%@/manifest";
static NSString *const kEkkoHubEndpointResource = @"courses/course/%@/resources/resource/%@";
static NSString *const kEkkoHubEndpointEnroll   = @"courses/course/%@/enroll";
static NSString *const kEkkoHubEndpointUnenroll = @"courses/course/%@/unenroll";
static NSString *const kEkkoHubEndpointCourse   = @"courses/course/%@";

// Ekko Hub XML processing queue
const char * kEkkoHubClientDispatchQueue = "org.ekkoproject.ios.player.hubclient.queue";

NSString *const kEkkoHubClientSessionEstablished = @"org.ekkoproject.ios.player.HubClientSessionEstablished";

// Ekko Hub Request Mothods
typedef NS_ENUM(NSUInteger, EkkoRequestMethodType) {
    EkkoRequestMethodGET,
    EkkoRequestMethodPOST,
};

// Maximum request attempts
static NSUInteger const kEkkoHubClientMaxAttepts = 3;

@interface HubRequestParameters : NSObject

@property (nonatomic) BOOL useSession;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic) EkkoRequestMethodType method;
@property (nonatomic) NSUInteger attempts;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) void (^response)(NSURLResponse *response, id responseObject);
@property (nonatomic, copy) void (^progress)(float progress);
+(HubRequestParameters *)hubRequestParametersWithSession:(BOOL)useSession
                                                endpoint:(NSString *)endpoint
                                              parameters:(NSDictionary *)parameters
                                                response:(void (^)(NSURLResponse *response, id responseObject))response;
-(NSMutableURLRequest *)buildURLRequest;
@end

@interface HubClient ()

@property (nonatomic, strong, readwrite) NSString *sessionId;
@property (nonatomic, strong, readwrite) NSString *sessionGuid;

@property (nonatomic) BOOL pendingSession;
@property (nonatomic, strong, readonly) NSMutableArray *pendingHubRequests;
@property (nonatomic, strong, readonly) dispatch_queue_t xmlDispatchQueue;

@end

@implementation HubClient

@synthesize pendingSession     = _pendingSession;
@synthesize pendingHubRequests = _pendingHubRequests;

+(HubClient *)hubClient {
    __strong static HubClient *_hubClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hubClient = [[HubClient alloc] initWithBaseURL:[NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:kEkkoHubClientURL]]];
    });
    return _hubClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        _pendingSession = NO;

        //DEBUG - Force invalid sessionId
        //[self setSessionId:nil];
        
        //DEBUG - Force 401 sessionId
        //[self setSessionId:@"abcdef1234567890"];
        
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    }
    return self;
}

-(NSMutableArray *)pendingHubRequests {
    if (!_pendingHubRequests) {
        _pendingHubRequests = [NSMutableArray array];
    }
    return _pendingHubRequests;
}

-(dispatch_queue_t)xmlDispatchQueue {
    static dispatch_queue_t _dispatch_queue = nil;
    static dispatch_once_t _dispatch_once_t;
    dispatch_once(&_dispatch_once_t, ^{
        _dispatch_queue = dispatch_queue_create(kEkkoHubClientDispatchQueue , DISPATCH_QUEUE_CONCURRENT);
    });
    return _dispatch_queue;
}

-(NSString *)sessionId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEkkoHubClientSessionId];
}

-(void)setSessionId:(NSString *)sessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sessionId) {
        [defaults setObject:sessionId forKey:kEkkoHubClientSessionId];
    }
    else {
        [defaults removeObjectForKey:kEkkoHubClientSessionId];
    }
}

-(BOOL)hasSession {
    NSString *sessionId = [self sessionId];
    NSString *sessionGuid = [self sessionGuid];
    return (sessionId && sessionGuid && [sessionGuid isEqualToString:[[TheKey theKey] getGuid]]);
}

-(NSString *)sessionGuid {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEkkoHubClientSessionGuid];
}

-(void)setSessionGuid:(NSString *)sessionGuid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sessionGuid) {
        [defaults setObject:sessionGuid forKey:kEkkoHubClientSessionGuid];
    }
    else {
        [defaults removeObjectForKey:kEkkoHubClientSessionGuid];
    }
}

-(void)establishSession {
    //Bail if a session is pending
    if([self pendingSession]) {
        return;
    }
    
    //Make sure sessionId is invalid
    [self setSessionId:nil];
    [self setPendingSession:YES];
    
    //TODO Fetch service url from Hub
    NSURL *serviceURL = [[self baseURL] URLByAppendingPathComponent:kEkkoHubEndpointLogin];
    
    [[TheKey theKey] getTicketForService:serviceURL completionHandler:^(NSString *ticket, NSError *error) {
        NSURL *loginURL = [[self baseURL] URLByAppendingPathComponent:kEkkoHubEndpointLogin];
        NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:loginURL];
        
        NSData *body = [[URLUtils encodeQueryParamsForDictionary:@{@"ticket": ticket}] dataUsingEncoding:NSUTF8StringEncoding];
        [loginRequest setHTTPMethod:@"POST"];
        [loginRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [loginRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        [loginRequest setHTTPBody:body];
        
        NSHTTPURLResponse *response = nil;
        NSError *loginError = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:loginRequest returningResponse:&response error:&loginError];
        if(data && [response statusCode] == 200) {
            NSString *sessionId = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self setSessionId:sessionId];
            [self setSessionGuid:[[TheKey theKey] getGuid]];
            [self setPendingSession:NO];
            [self enqueuePendingHubRequests];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kEkkoHubClientSessionEstablished object:self];
            });
        }
    }];
}

-(void)enqueuePendingHubRequests {
    while ([self.pendingHubRequests count] > 0) {
        HubRequestParameters *pending = (HubRequestParameters *)[self.pendingHubRequests objectAtIndex:0];
        [self.pendingHubRequests removeObjectAtIndex:0];
        
        [self hubRequestWithHubRequestParameters:pending];
    }
}

-(void)hubRequestWithHubRequestParameters:(HubRequestParameters *)requestParameters {
    //Return NSError if max attempts exceeded
    requestParameters.attempts++;
    if (requestParameters.attempts > kEkkoHubClientMaxAttepts) {
        //TODO: Create Max Attempts exceeded error code
        requestParameters.response(nil, [NSError errorWithDomain:@"EkkoHubClient" code:0 userInfo:nil]);
    }
    
    //Check if the request requires a session and if the session exists
    else if (requestParameters.useSession && ![self hasSession]) {
        //Add request to pending requests
        [self.pendingHubRequests addObject:requestParameters];
        
        //Begin establishing a session if it isn't currently happening
        if (!self.pendingSession) {
            [self establishSession];
        }
    }
    
    //Enqueue the request
    else {
        AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:[requestParameters buildURLRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            requestParameters.response([operation response], responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[operation response] statusCode] == 401) {
                //TODO: Make sure this is a 401 for CAS
                [self.pendingHubRequests addObject:requestParameters];
                if (!self.pendingSession) {
                    [self establishSession];
                }
            }
            else {
                requestParameters.response([operation response], error);
            }
        }];
        //Set the output stream if used
        if (requestParameters.outputStream) {
            requestOperation.outputStream = requestParameters.outputStream;
        }
        //Set download progress block if used
        if (requestParameters.progress) {
            [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                float progress = totalBytesRead / (float)totalBytesExpectedToRead;
                requestParameters.progress(progress);
            }];
        }
        [self enqueueHTTPRequestOperation:requestOperation];
    }
}

#pragma mark - Course List

-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit andCallback:(void (^)(NSArray *, BOOL, NSInteger, NSInteger))callback {
    NSDictionary *parameters = @{@"start": [NSString stringWithFormat:@"%d", (int)start],
                                 @"limit": [NSString stringWithFormat:@"%d", (int)limit]};
    [self hubRequestWithHubRequestParameters:[HubRequestParameters hubRequestParametersWithSession:YES endpoint:kEkkoHubEndpointCourses parameters:parameters response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:(NSData *)responseObject];
            dispatch_async(self.xmlDispatchQueue, ^{
                CoursesParser *coursesParser = [[CoursesParser alloc] initWithXMLParser:parser];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(coursesParser.courses, coursesParser.hasMore, coursesParser.start, coursesParser.limit);
                });
            });
        }
    }]];
}

#pragma mark - Manifest

-(void)getManifest:(NSString *)courseId callback:(void (^)(HubManifest *))callback {
    [self hubRequestWithHubRequestParameters:[HubRequestParameters hubRequestParametersWithSession:YES endpoint:[NSString stringWithFormat:kEkkoHubEndpointManifest, courseId] parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:(NSData *)responseObject];
            dispatch_async(self.xmlDispatchQueue, ^{
                ManifestParser *manifestParser = [[ManifestParser alloc] initWithXMLParser:parser];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(manifestParser.manifest);
                });
            });
        }
    }]];
}

#pragma mark - Resource

-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 callback:(void (^)(NSData *))callback {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointResource, courseId, sha1];
    [self hubRequestWithHubRequestParameters:[HubRequestParameters hubRequestParametersWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            callback((NSData *)responseObject);
        }
    }]];
}

-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 outputStream:(NSOutputStream *)outputStream progress:(void (^)(float))progress complete:(void (^)())complete {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointResource, courseId, sha1];
    HubRequestParameters *hubRequestParameters = [HubRequestParameters hubRequestParametersWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        complete();
    }];
    [hubRequestParameters setOutputStream:outputStream];
    if (progress) {
        [hubRequestParameters setProgress:progress];
    }
    [self hubRequestWithHubRequestParameters:hubRequestParameters];
}

#pragma mark - Course
-(void)getCourse:(NSString *)courseId callback:(void (^)(HubCourse *))callback {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointCourse, courseId];
    HubRequestParameters *hubRequestParameters = [HubRequestParameters hubRequestParametersWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:(NSData *)responseObject];
            dispatch_async(self.xmlDispatchQueue, ^{
                CourseParser *courseParser = [[CourseParser alloc] initWithXMLParser:parser];
                callback(courseParser.course);
            });
        }
    }];
    [self hubRequestWithHubRequestParameters:hubRequestParameters];
}

#pragma mark - Course Permissions
-(void)enrollInCourse:(NSString *)courseId callback:(void (^)(HubCourse *))callback {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointEnroll, courseId];
    HubRequestParameters *hubRequestParameters = [HubRequestParameters hubRequestParametersWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:(NSData *)responseObject];
            dispatch_async(self.xmlDispatchQueue, ^{
                CourseParser *courseParser = [[CourseParser alloc] initWithXMLParser:parser];
                callback(courseParser.course);
            });
        }
    }];
    [hubRequestParameters setMethod:EkkoRequestMethodPOST];
    [self hubRequestWithHubRequestParameters:hubRequestParameters];
}

-(void)unenrollFromCourse:(NSString *)courseId callback:(void (^)(BOOL))callback {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointUnenroll, courseId];
    HubRequestParameters *hubRequestParameters = [HubRequestParameters hubRequestParametersWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if ([responseObject isKindOfClass:[NSError class]]) {
            callback(NO);
        }
        else {
            callback(YES);
        }
    }];
    [hubRequestParameters setMethod:EkkoRequestMethodPOST];
    [self hubRequestWithHubRequestParameters:hubRequestParameters];
}

@end

@implementation HubRequestParameters

+(HubRequestParameters *)hubRequestParametersWithSession:(BOOL)useSession
                                                endpoint:(NSString *)endpoint
                                              parameters:(NSDictionary *)parameters
                                                response:(void (^)(NSURLResponse *response, id responseObject))response {
    HubRequestParameters *requestParams = [[HubRequestParameters alloc] init];
    [requestParams setUseSession:useSession];
    [requestParams setEndpoint:endpoint];
    [requestParams setParameters:parameters];
    [requestParams setResponse:response];
    return requestParams;
}

-(id)init {
    self = [super init];
    if (self) {
        self.useSession = NO;
        self.method = EkkoRequestMethodGET;
        self.attempts = 0;
    }
    return self;
}

-(NSMutableURLRequest *)buildURLRequest {
    HubClient *client = [HubClient hubClient];
    NSString *path = [self.endpoint copy];
    if(self.useSession) {
        NSString *sessionId = [client hasSession] ? [client sessionId] : @"0000";
        path = [NSString stringWithFormat:@"%@/%@", sessionId, path];
    }
    
    NSString *method;
    switch (self.method) {
        case EkkoRequestMethodPOST:
            method = @"POST";
            break;
        case EkkoRequestMethodGET:
        default:
            method = @"GET";
            break;
    }
    
    return [client requestWithMethod:method path:path parameters:self.parameters];
}

@end










