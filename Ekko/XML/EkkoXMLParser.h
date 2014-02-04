//
//  EkkoXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EkkoCloudXMLConstants.h"

@interface EkkoXMLParser : NSXMLParser <NSXMLParserDelegate>

@property (nonatomic) NSInteger schemaVersion;

-(NSString *)currentElement;
-(NSString *)appendString:(NSString *)string toString:(NSString *)current;

@end
