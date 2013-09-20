//
//  NSString+MD5.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

-(NSString *)MD5;

@end
