//
//  ManifestXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 1/31/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoXMLParser.h"

#import "Manifest+XMLModel.h"

@interface ManifestXMLParser : EkkoXMLParser

@property (nonatomic, strong) Manifest *manifest;

@end
