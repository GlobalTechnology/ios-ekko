//
//  ManifestParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLParser.h"
#import "HubManifest.h"

@interface ManifestParser : HubXMLParser

@property (nonatomic, strong) HubManifest *manifest;

@end
