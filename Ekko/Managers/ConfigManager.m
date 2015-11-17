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
static NSString *const kEkkoCloudAPIURL  = @"EkkoCloudAPIURL";
static NSString *const kEkkolabsShareURL = @"EkkolabsShareURL";

// Arclight API
static NSString *const kArclightAPIURL = @"ArclightAPIURL";
static NSString *const kArclightAPIKey = @"ArclightAPIKey";

// NewRelic
static NSString *const kNewRelicApplicationToken = @"NewRelicApplicationToken";

// Google Analytics
static NSString *const kGoogleAnalyticsTrackingID = @"GoogleAnalyticsTrackingID";

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
        NSMutableDictionary *configuration = [NSMutableDictionary dictionaryWithContentsOfFile:configFilePath];

#ifdef EKKOLABS_DEBUG
        // Overrride default values with development settings
        NSString *devConfigFilePath = [[NSBundle mainBundle] pathForResource:@"Config.dev" ofType:@"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:devConfigFilePath]) {
            [configuration addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:devConfigFilePath]];
        }
#endif

        _theKeyOAuth2ClientID = [configuration objectForKey:kTheKeyOAuth2ClientID];
        _theKeyOAuth2ServerURL = [NSURL URLWithString:[configuration objectForKey:kTheKeyOAuth2ServerURL]];

        _ekkoCloudAPIURL = [NSURL URLWithString:[configuration objectForKey:kEkkoCloudAPIURL]];
        _ekkolabsShareURL = [NSURL URLWithString:[configuration objectForKey:kEkkolabsShareURL]];

        _arclightAPIKey = [configuration objectForKey:kArclightAPIKey];
        _arclightAPIURL = [NSURL URLWithString:[configuration objectForKey:kArclightAPIURL]];

        _NewRelicApplicationToken = [configuration objectForKey:kNewRelicApplicationToken];

        _googleAnalyticsTrackingID = [configuration objectForKey:kGoogleAnalyticsTrackingID];
    }
    return self;
}

@end
