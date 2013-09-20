//
//  HubResource.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubResource : HubXMLModel

@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *resourceType;
@property (nonatomic) int64_t size;
@property (nonatomic, strong) NSString *sha1;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *uri;

@end
