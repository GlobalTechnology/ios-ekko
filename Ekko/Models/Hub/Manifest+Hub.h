//
//  Manifest+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest.h"
#import "HubManifest.h"

@interface Manifest (Hub)

-(void)syncWithHubManifest:(HubManifest *)hubManifest;

@end
