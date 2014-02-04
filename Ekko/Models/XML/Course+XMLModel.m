//
//  Course+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Course+XMLModel.h"

@implementation Course (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementCourse)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
}

@end
