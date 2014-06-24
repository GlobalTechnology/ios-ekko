//
//  Page+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Page+XMLModel.h"
#import "ManifestXMLParser.h"

@implementation Page (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementLessonText)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.pageId = [attributeDict objectForKey:kEkkoCloudXMLAttrTextId];
    self.manifest = [(ManifestXMLParser *)parser manifest];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    self.pageText = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}

@end
