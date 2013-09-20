//
//  HubXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubXMLConstants.h"

@interface HubXMLParser : NSObject<NSXMLParserDelegate>

-(id)initWithXMLParser:(NSXMLParser *)parser;

@end
