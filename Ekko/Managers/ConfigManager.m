//
//  ConfigManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 6/23/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ConfigManager.h"

// TheKey OAuth2
static NSString *const kTheKeyOAuth2ClientID = @"TheKeyOAuth2ClientID";
static NSString *const kTheKeyOAuth2ServerURL = @"TheKeyOAuth2ServerURL";

// Ekko
static NSString *const kEkkoCloudAPIURL = @"EkkoCloudAPIURL";
static NSString *const kEkkolabsVersion = @"EkkolabsVersion";

// Arclight API
static NSString *const kArclightAPIURL = @"ArclightAPIURL";
static NSString *const kArclightAPIKey = @"ArclightAPIKey";

// NewRelic
static NSString *const kNewRelicApplicationToken = @"NewRelicApplicationToken";

@implementation ConfigManager

+(ConfigManager *)sharedConfiguration {
    __strong static ConfigManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[ConfigManager alloc] init];
    });
    return _manager;
}

-(id)init {
    self = [super init];
    if (self) {
        NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *configuration = [NSDictionary dictionaryWithContentsOfFile:configFilePath];

        _theKeyOAuth2ClientID = [configuration objectForKey:kTheKeyOAuth2ClientID];
        _theKeyOAuth2ServerURL = [NSURL URLWithString:[configuration objectForKey:kTheKeyOAuth2ServerURL]];

        _ekkolabsVersion = [configuration objectForKey:kEkkolabsVersion];
        _ekkoCloudAPIURL = [NSURL URLWithString:[configuration objectForKey:kEkkoCloudAPIURL]];

        _arclightAPIKey = [configuration objectForKey:kArclightAPIKey];
        _arclightAPIURL = [NSURL URLWithString:[configuration objectForKey:kArclightAPIURL]];

        _NewRelicApplicationToken = [configuration objectForKey:kNewRelicApplicationToken];
    }
    return self;
}

@end
