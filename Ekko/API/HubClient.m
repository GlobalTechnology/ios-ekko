//
//  HubClient.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubClient.h"
#import "HubHTTPRequestOperation.h"
#import <TheKey.h>
#import "URLUtils.h"
#import "CoursesParser.h"
#import "ManifestParser.h"

// Ekko Hub API URL key in Info.plist
static NSString *const kEkkoHubURL = @"EkkoHubURL";

// NSUserDefaults keys
static NSString *const kEkkoHubSessionId   = @"EkkoHubSessionId";
static NSString *const kEkkoHubSessionGuid = @"EkkoHubSessionGuid";

// Ekko Hub API Endpoints
static NSString *const kEkkoHubEndpointLogin    = @"auth/login";
static NSString *const kEkkoHubEndpointService  = @"auth/service";
static NSString *const kEkkoHubEndpointCourses  = @"courses";
static NSString *const kEkkoHubEndpointManifest = @"courses/course/%@/manifest";
static NSString *const kEkkoHubEndpointResource = @"courses/course/%@/resources/resource/%@";

//Ekko Hub Parameters
static NSString *const kEkkoHubParamaterCoursesStart = @"start";
static NSString *const kEkkoHubParamaterCoursesLimit = @"limit";

@interface HubClient ()

@property (nonatomic, strong) dispatch_queue_t xmlQueue;
@property (nonatomic) BOOL pendingSession;

-(void)setSessionId:(NSString *)sessionId;
-(void)setSessionGuid:(NSString *)sessionGuid;

-(void)establishSession;

@end


@implementation HubClient

@synthesize pendingOperations = _pendingOperations;
@synthesize xmlQueue          = _xmlQueue;
@synthesize pendingSession    = _pendingSession;

+(HubClient *)sharedClient {
    __strong static HubClient *_client = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _client = [[HubClient alloc] initWithBaseURL:[NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:kEkkoHubURL]]];
    });
    return _client;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if(!self) {
        return nil;
    }

    _pendingSession = NO;

    //DEBUG - Force invalid sessionId
    //[self setSessionId:nil];

    //DEBUG - Force 401 sessionId
    //[self setSessionId:@"abcdef1234567890"];

    [self registerHTTPOperationClass:[HubHTTPRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/xml"];
    
    NSLog(@"Max Concurrent Operations: %ld", (long)self.operationQueue.maxConcurrentOperationCount);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];

    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSMutableArray *)pendingOperations {
    if(!_pendingOperations) {
        _pendingOperations = [NSMutableArray array];
    }
    return _pendingOperations;
}

-(dispatch_queue_t)xmlQueue {
    if (!_xmlQueue) {
        _xmlQueue = dispatch_queue_create("org.ekkoproject.ios.player.xml", DISPATCH_QUEUE_CONCURRENT);
    }
    return _xmlQueue;
}

-(NSString *)sessionId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEkkoHubSessionId];
}

-(NSString *)sessionGuid {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kEkkoHubSessionGuid];
}

-(void)setSessionId:(NSString *)sessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sessionId) {
        [defaults setObject:sessionId forKey:kEkkoHubSessionId];
    }
    else {
        [defaults removeObjectForKey:kEkkoHubSessionId];
    }
}

-(void)setSessionGuid:(NSString *)sessionGuid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(sessionGuid) {
        [defaults setObject:sessionGuid forKey:kEkkoHubSessionGuid];
    }
    else {
        [defaults removeObjectForKey:kEkkoHubSessionGuid];
    }
}

-(BOOL)hasSession {
    NSString *sessionId = [self sessionId];
    NSString *sessionGuid = [self sessionGuid];
    return (sessionId && sessionGuid && [sessionGuid isEqualToString:[[TheKey theKey] getGuid]]);
}

-(NSURL *)URLWithSession:(BOOL)useSession
                endpoint:(NSString *)endpoint {
    NSURL *url = useSession ? [[self baseURL] URLByAppendingPathComponent:[self sessionId] isDirectory:YES] : [self baseURL];
    url = [url URLByAppendingPathComponent:endpoint];
    return url;
}

-(void)HTTPOperationDidFinish:(NSNotification *)notification {
    if([[notification object] isKindOfClass:[HubHTTPRequestOperation class]]) {
        HubHTTPRequestOperation *operation = (HubHTTPRequestOperation *)[notification object];
        NSHTTPURLResponse *response = [operation response];
        if([response statusCode] == 401) {
            NSLog(@"401 Unauthorized: %@", [[operation.request URL] absoluteString]);
            //TODO: Make sure this is a CAS auth redirect
            [[self pendingOperations] addObject:operation];
            if(![self pendingSession]) {
                [self establishSession];
            }
        }
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
            [self enqueuePendingOperations];
        }
    }];
}

-(NSMutableURLRequest *)requestWithSession:(BOOL)useSession
                                  endpoint:(NSString *)endpoint
                                parameters:(NSDictionary *)parameters {
    NSString *path = [endpoint copy];
    if(useSession) {
        NSString *sessionId = [self hasSession] ? [self sessionId] : @"0000";
        path = [NSString stringWithFormat:@"%@/%@", sessionId, path];
    }
    return [self requestWithMethod:@"GET" path:path parameters:parameters];
}

-(void)apiGetRequestWithSession:(BOOL)useSession
                       endpoint:(NSString *)endpoint
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //Build the operation
    HubHTTPRequestOperation *operation = [self hubRequestOperationWithSession:useSession endpoint:endpoint parameters:parameters success:success failure:failure];

    if(useSession) {
        //Request requires a session
        if([self hasSession]) {
            //Session exists so enqueue the request. This isn't a gurantee the session is valid, we may get a 401.
            [self enqueueHTTPRequestOperation:operation];
        }
        else {
            //Session does not exist, add operation to pending operations
            [[self pendingOperations] addObject:operation];

            //Begin establishing a session if it isn't already in progress
            if(![self pendingSession]) {
                [self establishSession];
            }
        }
    }
    else {
        //Request doe not require a session so enqueue it
        [self enqueueHTTPRequestOperation:operation];
    }
}

-(HubHTTPRequestOperation *)hubRequestOperationWithSession:(BOOL)useSession
                                              endpoint:(NSString *)endpoint
                                            parameters:(NSDictionary *)parameters
                                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithSession:useSession endpoint:endpoint parameters:parameters];
    HubHTTPRequestOperation *operation = (HubHTTPRequestOperation *)[self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [operation setHubParameters:useSession endpoint:endpoint parameters:parameters];
    return operation;
}

-(void)enqueuePendingOperations {
    while([[self pendingOperations] count] > 0) {
        HubHTTPRequestOperation *pending = (HubHTTPRequestOperation *)[[self pendingOperations] objectAtIndex:0];
        [[self pendingOperations] removeObjectAtIndex:0];

        HubHTTPRequestOperation *operation = [self hubRequestOperationWithSession:[pending useSession]
                                                                     endpoint:[pending endpoint]
                                                                   parameters:[pending parameters]
                                                                      success:[pending success]
                                                                      failure:[pending failure]];
        [self enqueueHTTPRequestOperation:operation];
    }
}

#pragma mark - Courses

-(void)getCourses:(id<HubClientCoursesDelegate>)delegate {
    [self getCoursesStartingAt:0 withLimit:50 delegate:delegate];
}

-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit delegate:(id<HubClientCoursesDelegate>)delegate {
    NSDictionary *parameters = @{kEkkoHubParamaterCoursesStart: [NSString stringWithFormat:@"%d", (int)start],
                                 kEkkoHubParamaterCoursesLimit: [NSString stringWithFormat:@"%d", (int)limit]};
    [self apiGetRequestWithSession:YES endpoint:kEkkoHubEndpointCourses parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.xmlQueue, ^{
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
            CoursesParser *coursesParser = [[CoursesParser alloc] initWithXMLParser:parser];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate hubClientCourses:[coursesParser courses] hasMore:[coursesParser hasMore] start:[coursesParser start] limit:[coursesParser limit]];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"getCourses Error: %@", error);
    }];
}

#pragma mark - Course Manifest

-(void)getCourseManifest:(NSString *)courseId delegate:(id<HubClientManifestDelegate>)delegate {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointManifest, courseId];
    [self apiGetRequestWithSession:YES endpoint:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(self.xmlQueue, ^{
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseObject];
            ManifestParser *manifestParser = [[ManifestParser alloc] initWithXMLParser:parser];
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate hubClientManifest:[manifestParser manifest]];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)getCourseResource:(NSString *)courseId sha1:(NSString *)sha1 completionHandler:(void (^)(NSData *data))complete {
    NSString *endpoint = [NSString stringWithFormat:kEkkoHubEndpointResource, courseId, sha1];
    [self apiGetRequestWithSession:YES endpoint:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complete(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end