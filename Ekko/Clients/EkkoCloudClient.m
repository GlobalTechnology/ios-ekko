//
//  EkkoCloudClient.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/28/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoCloudClient.h"

#import <TheKeyOAuth2Client.h>
#import "ConfigManager.h"

// Session Id prefix
static NSString *const kEkkoCloudClientSessionId = @"EkkoCloudClient_SessionId_%@";

// HTTP Request Methods
static NSString *const kEkkoCloudClientHTTPMethodGET  = @"GET";
static NSString *const kEkkoCloudClientHTTPMethodPOST = @"POST";

// HTTP Header fields
static NSString *const kEkkoCloudClientHTTPHeaderAccept         = @"Accept";
static NSString *const kEkkoCloudClientHTTPHeaderAuthenticate   = @"WWW-Authenticate";
static NSString *const kEkkoCloudClientHTTPHeaderXEkkoStreamUri = @"X-Ekko-Stream-Uri";

// HTTP Content-Type
static NSString *const kEkkoCloudClientHTTPContentTypeText = @"text/plain";
static NSString *const kEkkoCloudClientHTTPContentTypeXML  = @"application/xml";
static NSString *const kEkkoCloudClientHTTPContentTypeJSON = @"application/json";

// API Endpoints
static NSString *const kEkkoCloudClientEndpointLogin    = @"auth/login";
static NSString *const kEkkoCloudClientEndpointService  = @"auth/service";
static NSString *const kEkkoCloudClientEndpointCourses  = @"courses";
static NSString *const kEkkoCloudClientEndpointManifest = @"courses/course/%@/manifest";
static NSString *const kEkkoCloudClientEndpointResource = @"courses/course/%@/resources/resource/%@";
static NSString *const kEkkoCloudClientEndpointEnroll   = @"courses/course/%@/enroll";
static NSString *const kEkkoCloudClientEndpointUnenroll = @"courses/course/%@/unenroll";
static NSString *const kEkkoCloudClientEndpointCourse   = @"courses/course/%@";
static NSString *const kEkkoCloudClientEndpointVideoDownload  = @"courses/course/%@/resources/video/%@/download";
static NSString *const kEkkoCloudClientEndpointVideoStream    = @"courses/course/%@/resources/video/%@/stream.m3u8?type=HLS";
static NSString *const kEkkoCloudClientEndpointVideoThumbnail = @"courses/course/%@/resources/video/%@/thumbnail";

// API Parameters
static NSString *const kEkkoCloudClientParameterTicket = @"ticket";
static NSString *const kEkkoCloudClientParameterGuest  = @"guest";
static NSString *const kEkkoCloudClientParameterStart  = @"start";
static NSString *const kEkkoCloudClientParameterLimit  = @"limit";

// Maximum request attempts
static NSUInteger const kEkkoCloudClientMaxAttempts = 3;

@interface EkkoCloudRequest : NSObject
@property (nonatomic) BOOL useSession;
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSDictionary *parameters;
@property (nonatomic, copy) NSString *method;
@property (nonatomic) NSUInteger attempts;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, copy) void (^response)(NSURLResponse *response, id responseObject);
@property (nonatomic, copy) void (^progress)(float progress);
@property (nonatomic, copy) void (^constructingBodyWithBlock)(id <AFMultipartFormData> formData);
@property (nonatomic, copy) NSURLRequest* (^redirectResponse)(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse);
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> *requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> *responseSerializer;
+(EkkoCloudRequest *)ekkoCloudRequestWithSession:(BOOL)useSession
                                        endpoint:(NSString *)endpoint
                                      parameters:(NSDictionary *)parameters
                                        response:(void (^)(NSURLResponse *response, id responseObject))response;
@end

@interface EkkoCloudClient () {
    NSMutableArray *_pendingRequests;
}
@property (nonatomic, strong, readwrite) NSString *guid;
@property (nonatomic, strong) NSString *sessionId;
@property (atomic) BOOL pendingSession;
-(EkkoCloudClient *)initWithGUID:(NSString *)guid;
@end

@implementation EkkoCloudClient

@synthesize guid            = _guid;
@synthesize pendingSession  = _pendingSession;

+(EkkoCloudClient *)sharedClientForGUID:(NSString *)guid {
    __strong static NSMutableDictionary *_clients = nil;
    static dispatch_once_t clientsToken;
    dispatch_once(&clientsToken, ^{
        _clients = [NSMutableDictionary dictionary];
    });

    EkkoCloudClient *client = nil;
    @synchronized(_clients) {
        guid = guid ?: [[TheKeyOAuth2Client sharedOAuth2Client] guid];
        client = (EkkoCloudClient *)[_clients objectForKey:guid];
        if(client == nil) {
            client = [[EkkoCloudClient alloc] initWithGUID:guid];
            [_clients setObject:client forKey:guid];
        }
    }
    return client;
}

+(EkkoCloudClient *)sharedClient {
    return [EkkoCloudClient sharedClientForGUID:nil];
}

-(EkkoCloudClient *)initWithGUID:(NSString *)guid {
    self = [super initWithBaseURL:[ConfigManager sharedConfiguration].ekkoCloudAPIURL];
    if(self != nil) {
        _pendingSession = NO;
        _pendingRequests = [NSMutableArray array];
        [self setGuid:guid];

        // Default request erializer with Accept header of application/xml
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [self.requestSerializer setValue:kEkkoCloudClientHTTPContentTypeXML forHTTPHeaderField:kEkkoCloudClientHTTPHeaderAccept];

        // Default response serializer
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

-(void)addPendingRequest:(EkkoCloudRequest *)ekkoCloudRequest {
    @synchronized(_pendingRequests) {
        [_pendingRequests addObject:ekkoCloudRequest];
    }
}

-(NSString *)sessionId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:kEkkoCloudClientSessionId, self.guid]];
}

-(void)setSessionId:(NSString *)sessionId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:kEkkoCloudClientSessionId, self.guid];
    if(sessionId) {
        [defaults setObject:sessionId forKey:key];
    }
    else {
        [defaults removeObjectForKey:key];
    }
}

-(BOOL)hasSession {
    return self.sessionId ? YES : NO;
}

-(NSMutableURLRequest *)urlRequestWithEkkoCloudRequest:(EkkoCloudRequest *)ekkoCloudRequest {
    NSString *path = [ekkoCloudRequest.endpoint copy];
    if (ekkoCloudRequest.useSession) {
        NSString *sessionId  = self.sessionId ?: @"abc123";
        path = [NSString stringWithFormat:@"%@/%@", sessionId, path];
    }
    NSString *url = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];

    // Request serializer to use for the request
    AFHTTPRequestSerializer<AFURLRequestSerialization> *requestSerializer = ekkoCloudRequest.requestSerializer ?: self.requestSerializer;

    // Build Multipart form if constructingBodyWithBlock is set
    if (ekkoCloudRequest.constructingBodyWithBlock) {
        NSError *error = nil;
        return [requestSerializer multipartFormRequestWithMethod:ekkoCloudRequest.method
                                                       URLString:url
                                                      parameters:ekkoCloudRequest.parameters
                                       constructingBodyWithBlock:ekkoCloudRequest.constructingBodyWithBlock
                                                           error:&error];
    }
    NSError *error = nil;
    return [requestSerializer requestWithMethod:ekkoCloudRequest.method URLString:url parameters:ekkoCloudRequest.parameters error:&error];
}

-(void)HTTPRequestOperationWithEkkoCloudRequest:(EkkoCloudRequest *)ekkoCloudRequest {
    // Increment attempt counter
    ekkoCloudRequest.attempts++;

    // Return NSError if max attempts exceeded
    if (ekkoCloudRequest.attempts > kEkkoCloudClientMaxAttempts) {
        ekkoCloudRequest.response(nil, [NSError errorWithDomain:@"EkkoCloudClient" code:0 userInfo:nil]);
        return;
    }

    // Check if the request requires a session and if the session exists
    if (ekkoCloudRequest.useSession && ![self hasSession]) {
        //Add request to pending requests
        [self addPendingRequest:ekkoCloudRequest];

        //Begin establishing a session if it isn't currently happening
        [self establishEkkoCloudSession];
        return;
    }

    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:[self urlRequestWithEkkoCloudRequest:ekkoCloudRequest] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ekkoCloudRequest.response([operation response], responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // If request failed with 401, and reason is CAS authentication
        // re-establish session and try again
        if ([[operation response] statusCode] == 401) {
            NSDictionary *headers = [[operation response] allHeaderFields];
            NSString *authHeader = [headers objectForKey:kEkkoCloudClientHTTPHeaderAuthenticate];
            if (authHeader && [authHeader rangeOfString:@"CAS"].location != NSNotFound) {
                //Add request to pending requests
                [self addPendingRequest:ekkoCloudRequest];
                [self establishEkkoCloudSession];
                return;
            }
        }
        // Otherwise throw an error
        ekkoCloudRequest.response([operation response], error);
    }];

    //Set the output stream if used
    if (ekkoCloudRequest.outputStream) {
        requestOperation.outputStream = ekkoCloudRequest.outputStream;
    }

    //Set download progress block if used
    if (ekkoCloudRequest.progress) {
        [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float progress = totalBytesRead / (float)totalBytesExpectedToRead;
            ekkoCloudRequest.progress(progress);
        }];
    }

    //Set the redirect response if provided
    if (ekkoCloudRequest.redirectResponse) {
        [requestOperation setRedirectResponseBlock:ekkoCloudRequest.redirectResponse];
    }

    //Set a custom responseSerializer if provided
    if (ekkoCloudRequest.responseSerializer) {
        [requestOperation setResponseSerializer:ekkoCloudRequest.responseSerializer];
    }

    // Add the operation to the queue
    [self.operationQueue addOperation:requestOperation];
}

-(void)establishEkkoCloudSession {
    //Bail if a session is pending
    if([self pendingSession]) {
        return;
    }
    [self setPendingSession:YES];

    //Make sure sessionId is invalid
    [self setSessionId:nil];

    EkkoCloudRequest *loginRequest = [EkkoCloudRequest ekkoCloudRequestWithSession:NO endpoint:kEkkoCloudClientEndpointLogin parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *sessionId = responseObject[@"id"];
            NSString *guid = responseObject[@"guid"];
            if ([self.guid caseInsensitiveCompare:guid] == NSOrderedSame) {
                [self setSessionId:sessionId];
                [self setPendingSession:NO];
                [self processPendingRequests];
            }
        }
    }];

    // Login request is POST
    loginRequest.method = kEkkoCloudClientHTTPMethodPOST;

    // Set login request serializer and Accept Header to application/json
    loginRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
    [loginRequest.requestSerializer setValue:kEkkoCloudClientHTTPContentTypeJSON forHTTPHeaderField:kEkkoCloudClientHTTPHeaderAccept];

    // Set login request response serializer to JSON
    loginRequest.responseSerializer = [AFJSONResponseSerializer serializer];

    // GUEST guid
    if ([self.guid isEqualToString:TheKeyOAuth2GuestGUID]) {
        [loginRequest setConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFormData:[@"true" dataUsingEncoding:NSUTF8StringEncoding] name:kEkkoCloudClientParameterGuest];
        }];
        [self HTTPRequestOperationWithEkkoCloudRequest:loginRequest];
        return;
    }

    // Logged in User - fetch service url needed for TheKey ticket call
    EkkoCloudRequest *serviceRequest = [EkkoCloudRequest ekkoCloudRequestWithSession:NO endpoint:kEkkoCloudClientEndpointService parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            NSString *serviceURL = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //Fetch a CAS ticket using the service URL
            [[TheKeyOAuth2Client sharedOAuth2Client] ticketForServiceURL:[NSURL URLWithString:serviceURL] complete:^(NSString *ticket) {
                if (ticket) {
                    //Use the CAS ticket for authentication with Ekko Hub
                    [loginRequest setConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        [formData appendPartWithFormData:[ticket dataUsingEncoding:NSUTF8StringEncoding] name:kEkkoCloudClientParameterTicket];
                    }];
                    //Start the Login request
                    [self HTTPRequestOperationWithEkkoCloudRequest:loginRequest];
                }
            }];
        }

    }];
    serviceRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
    [serviceRequest.requestSerializer setValue:kEkkoCloudClientHTTPContentTypeText forHTTPHeaderField:kEkkoCloudClientHTTPHeaderAccept];
    [self HTTPRequestOperationWithEkkoCloudRequest:serviceRequest];
}

-(void)processPendingRequests {
    @synchronized(_pendingRequests) {
        while ([_pendingRequests count] > 0) {
            EkkoCloudRequest *pendingRequest = (EkkoCloudRequest *)[_pendingRequests objectAtIndex:0];
            [_pendingRequests removeObjectAtIndex:0];

            [self HTTPRequestOperationWithEkkoCloudRequest:pendingRequest];
        }
    }
}

#pragma mark - Course List

-(void)getCoursesStartingAt:(NSInteger)start withLimit:(NSInteger)limit completeBlock:(void (^)(NSData *, NSError *))complete {
    NSDictionary *parameters = @{kEkkoCloudClientParameterStart: [NSString stringWithFormat:@"%d", (int)start],
                                 kEkkoCloudClientParameterLimit: [NSString stringWithFormat:@"%d", (int)limit]};
    [self HTTPRequestOperationWithEkkoCloudRequest:[EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:kEkkoCloudClientEndpointCourses parameters:parameters response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject, nil);
        }
        else {
            complete(nil, (NSError *)responseObject);
        }
    }]];
}

#pragma mark - Manifest

-(void)getManifest:(NSString *)courseId completeBlock:(void (^)(NSData *, NSError *))complete {
    [self HTTPRequestOperationWithEkkoCloudRequest:[EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:[NSString stringWithFormat:kEkkoCloudClientEndpointManifest, courseId] parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject, nil);
        }
        else {
            complete(nil, (NSError *)responseObject);
        }
    }]];
}

#pragma mark - Resource

-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 completeBlock:(void (^)(NSData *))complete {
    NSString *endpoint = [NSString stringWithFormat:kEkkoCloudClientEndpointResource, courseId, sha1];
    [self HTTPRequestOperationWithEkkoCloudRequest:[EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject);
        }
    }]];
}

-(void)getResource:(NSString *)courseId sha1:(NSString *)sha1 outputStream:(NSOutputStream *)outputStream progressBlock:(void (^)(float))progress completeBlock:(void (^)())complete {
    NSString *endpoint = [NSString stringWithFormat:kEkkoCloudClientEndpointResource, courseId, sha1];
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        complete();
    }];
    [request setOutputStream:outputStream];
    if (progress) {
        [request setProgress:progress];
    }
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

#pragma mark - Course

-(void)getCourse:(NSString *)courseId completeBlock:(void (^)(NSData *, NSError *))complete {
    NSString *endpoint = [NSString stringWithFormat:kEkkoCloudClientEndpointCourse, courseId];
    [self HTTPRequestOperationWithEkkoCloudRequest:[EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject, nil);
        }
        else {
            complete(nil, (NSError *)responseObject);
        }
    }]];
}

#pragma mark - Course Permissions

-(void)enrollInCourse:(NSString *)courseId completeBlock:(void (^)(NSData *, NSError *))complete {
    // 200 on success, response is XML with new permission
    // 401/404 on failure
    NSString *endpoint = [NSString stringWithFormat:kEkkoCloudClientEndpointEnroll, courseId];
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject, nil);
        }
        else {
            complete(nil, (NSError *)responseObject);
        }
    }];
    [request setMethod:kEkkoCloudClientHTTPMethodPOST];
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

-(void)unenrollFromCourse:(NSString *)courseId completeBlock:(void (^)(NSData *, NSError *))complete {
    // 200 on success, response is XML if guid still has access to the course, empty if not
    NSString *endpoint = [NSString stringWithFormat:kEkkoCloudClientEndpointUnenroll, courseId];
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:endpoint parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSData class]]) {
            complete((NSData *)responseObject, nil);
        }
        else {
            complete(nil, (NSError *)responseObject);
        }
    }];
    [request setMethod:kEkkoCloudClientHTTPMethodPOST];
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

#pragma mark - Ekko Cloud Video

-(void)getVideoStreamURL:(NSString *)courseId videoId:(NSString *)videoId completeBlock:(void (^)(NSURL *))complete {
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:[NSString stringWithFormat:kEkkoCloudClientEndpointVideoStream, courseId, videoId] parameters:nil response:^(NSURLResponse *response, id responseObject) {
        if (responseObject && ![responseObject isKindOfClass:[NSError class]]) {
            NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
            NSString *stream = [headers objectForKey:kEkkoCloudClientHTTPHeaderXEkkoStreamUri];
            complete([NSURL URLWithString:stream]);
        }
    }];
    [request setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

-(void)getVideoThumbnailURL:(NSString *)courseId videoId:(NSString *)videoId completeBlock:(void (^)(NSURL *))complete {
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:[NSString stringWithFormat:kEkkoCloudClientEndpointVideoThumbnail, courseId, videoId] parameters:nil response:^(NSURLResponse *response, id responseObject) {
        // Empty success block
    }];
    [request setRedirectResponse:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        if (redirectResponse == nil) {
            //Not a redirect, something changed with the initial request URL
            return request;
        }
        //Return the redirect URL and then abort the original request.
        complete([request.URL copy]);
        return nil;
    }];
    [request setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

-(void)getVideoDownloadURL:(NSString *)courseId videoId:(NSString *)videoId completeBlock:(void (^)(NSURL *))complete {
    EkkoCloudRequest *request = [EkkoCloudRequest ekkoCloudRequestWithSession:YES endpoint:[NSString stringWithFormat:kEkkoCloudClientEndpointVideoDownload, courseId, videoId] parameters:nil response:^(NSURLResponse *response, id responseObject) {
        // Empty success block
    }];
    [request setRedirectResponse:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        if (redirectResponse == nil) {
            //Not a redirect, something changed with the initial request URL
            return request;
        }
        //Return the redirect URL and then abort the original request.
        complete([request.URL copy]);
        return nil;
    }];
    [request setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [self HTTPRequestOperationWithEkkoCloudRequest:request];
}

@end

#pragma mark - EkkoCloudRequest

@implementation EkkoCloudRequest

+(EkkoCloudRequest *)ekkoCloudRequestWithSession:(BOOL)useSession
                                        endpoint:(NSString *)endpoint
                                      parameters:(NSDictionary *)parameters
                                        response:(void (^)(NSURLResponse *, id))response {
    EkkoCloudRequest *request = [[EkkoCloudRequest alloc] init];
    [request setUseSession:useSession];
    [request setEndpoint:endpoint];
    [request setParameters:parameters];
    [request setResponse:response];
    return request;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        self.useSession = NO;
        self.method = kEkkoCloudClientHTTPMethodGET;
        self.attempts = 0;
    }
    return self;
}

@end
