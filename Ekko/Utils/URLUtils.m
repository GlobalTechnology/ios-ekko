//
//  URLUtils.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+(NSString *)urlEncodeString:(NSString *)value {
    CFStringRef valueRef = (__bridge_retained CFStringRef)value;
    NSString *escapedValue = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, valueRef, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    CFRelease(valueRef);
    return escapedValue;
}

+(NSString *)encodeQueryParamsForDictionary:(NSDictionary *)dictionary {
    NSMutableArray *pairs = [NSMutableArray array];
    for(NSString *key in [dictionary keyEnumerator]) {
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", [self urlEncodeString:key], [self urlEncodeString:(NSString *)[dictionary objectForKey:key]]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

@end
