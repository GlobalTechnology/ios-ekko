//
//  NewResource+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Resource+XMLModel.h"

@implementation Resource (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementResource)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.resourceId = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceId];
    NSString *type = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceType];
    if ([type isEqualToString:kEkkoCloudXMLValueResourceTypeFile]) {
        self.type = EkkoResourceTypeFile;
        NSString *size = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceSize];
        if (size == nil) {
            self.size = 0;
        }
        else {
            self.size = strtoull([size UTF8String], NULL, 10);
        }
        self.sha1     = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceSha1];
        self.mimeType = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceMimeType];
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueResourceTypeURI]) {
        self.type = EkkoResourceTypeURI;
        self.uri  = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceURI];

        NSString *provider = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceProvider];
        if (provider == nil) {
            self.provider = EkkoResourceProviderNone;
        }
        else if ([provider isEqualToString:kEkkoCloudXMLValueResourceProviderYouTube]) {
            self.provider = EkkoResourceProviderYouTube;
        }
        else if ([provider isEqualToString:kEkkoCloudXMLValueResourceProviderVimeo]) {
            self.provider = EkkoResourceProviderVimeo;
        }
        else {
            self.provider = EkkoResourceProviderUnknown;
        }
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueResourceTypeECV]) {
        self.type    = EkkoResourceTypeECV;
        self.videoId = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceVideoId];
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueResourceTypeArclight]) {
        self.type  = EkkoResourceTypeArclight;
        self.refId = [attributeDict objectForKey:kEkkoCloudXMLAttrResourceRefId];
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueResourceTypeDynamic]) {
        self.type = EkkoResourceTypeDynamic;
    }
    else {
        self.type = EkkoResourceTypeUnknown;
    }
}

@end
