//
//  HubQuestionMC.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubQuestionMC.h"

@implementation HubQuestionMC

@synthesize questionText = _questionText;
@synthesize options      = _options;

-(NSMutableArray *)options {
    if (!_options) {
        _options = [NSMutableArray array];
    }
    return _options;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];

    if ([elementName isEqualToString:kEkkoHubXMLElementQuizQuestionOption]) {
        [[self options] addObject:[[HubOption alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:self.schemaVersion]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[self currentElement] isEqualToString:kEkkoHubXMLElementQuizQuestionText]) {
        [self setQuestionText:[self appendString:string toString:[self questionText]]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    [self parser:parser foundCharacters:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
}

@end
