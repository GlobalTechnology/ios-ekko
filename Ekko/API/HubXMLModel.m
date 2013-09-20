//
//  HubXMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubXMLModel ()
@property (nonatomic, weak) id<NSXMLParserDelegate> parentDelegate;
@end

@implementation HubXMLModel

@synthesize parentDelegate = _parentDelegate;
@synthesize elements       = _elements;
@synthesize schemaVersion  = _schemaVersion;

-(id)initWithXMLParser:(NSXMLParser *)parser
               element:(NSString *)elementName
            attributes:(NSDictionary *)attributeDict
         schemaVersion:(int64_t)schemaVersion {
    self = [self init];
    if (self) {
        _schemaVersion = schemaVersion;
        _parentDelegate = [parser delegate];
        [parser setDelegate:self];

        [self parser:parser didStartElement:elementName namespaceURI:nil qualifiedName:nil attributes:attributeDict];
    }
    return self;
}

-(NSMutableArray *)elements {
    if (!_elements) {
        _elements = [NSMutableArray array];
    }
    return _elements;
}

-(NSString *)parentElement {
    NSUInteger index = [[self elements] count];
    if (index > 1) {
        return [[self elements] objectAtIndex:index - 2];
    }
    return nil;
}

-(NSString *)currentElement {
    return (NSString *)[[self elements] lastObject];
}

-(BOOL)isRootElement {
    return ([[self elements] count] == 1);
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

#pragma mark - NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
#ifdef DEBUG
//    NSLog(@" + %@::%@", [[self class] description], elementName);
#endif
    [[self elements] addObject:elementName];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
#ifdef DEBUG
//    NSLog(@" - %@::%@", [[self class] description], elementName);
#endif
    if ([[self currentElement] isEqualToString:elementName]) {
        [[self elements] removeLastObject];

        if ([[self elements] count] == 0) {
            [parser setDelegate:[self parentDelegate]];
            [[self parentDelegate] parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
            [self setParentDelegate:nil];
        }
    }
    else {
        //Something happened
        NSLog(@"Parsing Aborted: %@", elementName);
        [parser abortParsing];
    }
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([[self parentDelegate] respondsToSelector:@selector(parser:parseErrorOccurred:)]) {
        [[self parentDelegate] parser:parser parseErrorOccurred:parseError];
    }
}

@end
