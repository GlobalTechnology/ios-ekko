//
//  ConfigManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 6/23/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigManager : NSObject

@property (nonatomic, strong, readonly) NSString *theKeyOAuth2ClientID;
@property (nonatomic, strong, readonly) NSURL *theKeyOAuth2ServerURL;

@property (nonatomic, strong, readonly) NSString *ekkolabsVersion;
@property (nonatomic, strong, readonly) NSURL *ekkoCloudAPIURL;

@property (nonatomic, strong, readonly) NSString *arclightAPIKey;
@property (nonatomic, strong, readonly) NSURL *arclightAPIURL;

@property (nonatomic, strong, readonly) NSString *NewRelicApplicationToken;

+(ConfigManager *)sharedConfiguration;

@end
