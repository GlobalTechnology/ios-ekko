//
//  HTTPClient.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/30/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface HTTPClient : AFHTTPRequestOperationManager

+(HTTPClient *)sharedClient;

@end
