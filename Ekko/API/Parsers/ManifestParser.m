//
//  ManifestParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "ManifestParser.h"

@implementation ManifestParser

@synthesize manifest = _manifest;

-(id)init {
    self = [super init];
    if (self) {
        _manifest = nil;
    }
    return self;
}

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEkkoHubXMLElementManifest]) {
        int64_t schemaVersion = [[attributeDict objectForKey:kEkkoHubXMLAttrSchemaVersion] integerValue];
        [self setManifest:[[HubManifest alloc] initWithXMLParser:parser element:elementName attributes:attributeDict schemaVersion:schemaVersion]];
    }
}

@end
