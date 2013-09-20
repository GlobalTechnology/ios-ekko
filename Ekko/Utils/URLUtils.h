//
//  URLUtils.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtils : NSObject
+(NSString *)urlEncodeString:(NSString *)value;
+(NSString *)encodeQueryParamsForDictionary:(NSDictionary *)dictionary;
@end
