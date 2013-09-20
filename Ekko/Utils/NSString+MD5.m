//
//  NSString+MD5.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

-(NSString *)MD5 {
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [md5 appendFormat:@"%02x", result[i]];
    }
    return [NSString stringWithString:md5];
}

@end
