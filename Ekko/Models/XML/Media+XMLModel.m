//
//  Media+XMLModel.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Media+XMLModel.h"
#import "ManifestXMLParser.h"

@implementation Media (XMLModel)

EKKO_XML_MODEL_INIT(kEkkoCloudXMLElementLessonMedia)

-(void)ekkoXMLParser:(EkkoXMLParser *)parser didInitElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.mediaId     = [attributeDict objectForKey:kEkkoCloudXMLAttrMediaId];
    self.resourceId  = [attributeDict objectForKey:kEkkoCloudXMLAttrResource];
    self.thumbnailId = [attributeDict objectForKey:kEkkoCloudXMLAttrThumbnail];

    NSString *type = [attributeDict objectForKey:kEkkoCloudXMLAttrMediaType];
    if ([type isEqualToString:kEkkoCloudXMLValueMediaTypeAudio]) {
        self.mediaType = EkkoMediaTypeAudio;
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueMediaTypeImage]) {
        self.mediaType = EkkoMediaTypeImage;
    }
    else if ([type isEqualToString:kEkkoCloudXMLValueMediaTypeVideo]) {
        self.mediaType = EkkoMediaTypeVideo;
    }
    else {
        self.mediaType = EkkoMediaTypeUnknown;
    }

    //Set Parent Manifest
    self.manifest = [(ManifestXMLParser *)parser manifest];
}

@end
