//
//  Permission+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/5/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Permission+XMLModel.h"

@implementation Permission (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementPermission)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.guid     = [attributeDict objectForKey:kEkkoCloudXMLAttrPermissionGuid];
    self.enrolled = [[attributeDict objectForKey:kEkkoCloudXMLAttrPermissionEnrolled] boolValue];
    self.admin    = [[attributeDict objectForKey:kEkkoCloudXMLAttrPermissionAdmin] boolValue];
    self.pending  = [[attributeDict objectForKey:kEkkoCloudXMLAttrPermissionPending] boolValue];
    self.contentVisible = [[attributeDict objectForKey:kEkkoCloudXMLAttrPermissionContentVisible] boolValue];
}

@end
