//
//  EkkoXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoXMLParser.h"

@interface EkkoXMLParser ()
@property (nonatomic, strong, readonly) NSMutableArray *elements;
@end

@implementation EkkoXMLParser

@synthesize schemaVersion = _schemaVersion;
@synthesize elements      = _elements;

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (!self) {
        return nil;
    }

    [self initXMLParser];
    return self;
}

-(id)initWithStream:(NSInputStream *)stream {
    self = [super initWithStream:stream];
    if (!self) {
        return nil;
    }

    [self initXMLParser];
    return self;
}

-(id)initWithContentsOfURL:(NSURL *)url {
    self = [super initWithContentsOfURL:url];
    if (!self) {
        return nil;
    }

    [self initXMLParser];
    return self;
}

-(void)initXMLParser {
    _elements = [NSMutableArray array];
    // Delgate XML parsing events to self
    [self setDelegate:self];

    // Default parser options for Ekko
    [self setShouldProcessNamespaces:NO];
    [self setShouldReportNamespacePrefixes:YES];
    [self setShouldResolveExternalEntities:NO];
}

-(NSString *)appendString:(NSString *)string toString:(NSString *)current {
    if (string == nil && current == nil) {
        return nil;
    }
    if (string == nil) {
        return current;
    }
    if (current == nil) {
        current = @"";
    }
    return [current stringByAppendingString:string];
}

-(NSString *)currentElement {
    return [self.elements lastObject];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"+ %@", elementName);
    [self.elements addObject:elementName];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([[self.elements lastObject] isEqualToString:elementName]) {
        NSLog(@"- %@", elementName);
        [self.elements removeLastObject];
    }
}

@end
