//
//  Permission+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Permission.h"
#import "HubPermission.h"

@interface Permission (Hub)

-(void)syncFromHubPermission:(HubPermission *)hubPermission;

@end
