//
//  HubXMLModel.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubXMLConstants.h"

@interface HubXMLModel : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic) int64_t schemaVersion;

-(id)initWithXMLParser:(NSXMLParser *)parser
               element:(NSString *)elementName
            attributes:(NSDictionary *)attributeDict
         schemaVersion:(int64_t)schemaVersion;

-(NSString *)parentElement;
-(NSString *)currentElement;
-(BOOL)isRootElement;

-(NSString *)appendString:(NSString *)string toString:(NSString *)current;

@end
