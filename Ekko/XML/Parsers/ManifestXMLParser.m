//
//  ManifestXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ManifestXMLParser.h"

@implementation ManifestXMLParser

@synthesize manifest = _manifest;

-(BOOL)parse {
    BOOL result = [super parse];
    if (!result) {
        [self setManifest:nil];
    }
    return result;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    if ([elementName isEqualToString:kEkkoCloudXMLElementManifest]) {
        self.schemaVersion = [[attributeDict objectForKey:kEkkoCloudXMLAttrSchemaVersion] integerValue];
        self.manifest = [[Manifest alloc] initWithEkkoXMLParser:self element:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
}

@end
