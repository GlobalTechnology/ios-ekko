//
//  HubPermission.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubPermission.h"

@implementation HubPermission

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    
    if ([elementName isEqualToString:kEkkoHubXMLElementPermission]) {
        [self setGuid:[attributeDict objectForKey:kEkkoHubXMLAttrPermissionGuid]];
        [self setEnrolled:[[attributeDict objectForKey:kEkkoHubXMLAttrPermissionEnrolled] boolValue]];
        [self setAdmin:[[attributeDict objectForKey:kEkkoHubXMLAttrPermissionAdmin] boolValue]];
        [self setPending:[[attributeDict objectForKey:kEkkoHubXMLAttrPermissionPending] boolValue]];
        [self setContentVisible:[[attributeDict objectForKey:kEkkoHubXMLAttrPermissionContentVisible] boolValue]];
    }
}

@end
