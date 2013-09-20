//
//  HubXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLParser.h"

@implementation HubXMLParser

-(id)initWithXMLParser:(NSXMLParser *)parser {
    self = [self init];
    if (self) {
        [parser setDelegate:self];

        //Setup the parser
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:YES];
        [parser setShouldResolveExternalEntities:NO];

        //Begin parsing the document - this blocks
        [parser parse];
    }
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parser Error Occurred: %@", parseError);
}

@end
