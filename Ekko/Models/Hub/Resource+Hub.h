//
//  Resource+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource.h"
#import "HubResource.h"

@interface Resource (Hub)

-(void)updateFromHubResource:(HubResource *)hubResource;

@end
