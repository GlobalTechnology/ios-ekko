//
//  EkkoXMLModel.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "EkkoXMLParser.h"

#ifndef EKKO_XML_MODEL_h
#define EKKO_XML_MODEL_h

#define EKKO_XML_MODEL_INIT(_element_) \
@dynamic parentDelegate; \
-(id<NSXMLParserDelegate>)parentDelegate { \
    return (id<NSXMLParserDelegate>)objc_getAssociatedObject(self, @selector(parentDelegate)); \
} \
-(void)setParentDelegate:(id<NSXMLParserDelegate>)parentDelegate { \
    objc_setAssociatedObject(self, @selector(parentDelegate), parentDelegate, OBJC_ASSOCIATION_ASSIGN); \
} \
-(id)initWithEkkoXMLParser:(EkkoXMLParser *)parser element:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict { \
    self = [super init]; \
    if (!self) { \
        return nil; \
    } \
    [self setParentDelegate:parser.delegate]; \
    [parser setDelegate:self]; \
    [self ekkoXMLParser:parser didInitElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict]; \
    return self; \
} \
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName { \
    [(EkkoXMLParser *)parser parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; \
    if ([elementName isEqualToString:_element_]) { \
        if ([self respondsToSelector:@selector(ekkoXMLParser:didEndElement:namespaceURI:qualifiedName:)]) { \
            [self ekkoXMLParser:(EkkoXMLParser *)parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; \
        } \
        [parser setDelegate:[self parentDelegate]]; \
        [self setParentDelegate:nil]; \
    } \
}
#endif

//static NSString *const kEkkoXMLModelParentDelegate = @"kEkkoXMLModelParentDelegate";

@protocol EkkoXMLModel <NSObject, NSXMLParserDelegate>

@required
@property (nonatomic, weak) id<NSXMLParserDelegate> parentDelegate;
-(id)initWithEkkoXMLParser:(EkkoXMLParser *)parser element:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;

@optional
-(void)ekkoXMLParser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;

@end
