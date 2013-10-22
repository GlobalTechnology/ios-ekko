//
//  Permission+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Permission+Hub.h"

@implementation Permission (Hub)

-(void)syncFromHubPermission:(HubPermission *)hubPermission {
    [self setGuid:hubPermission.guid];
    [self setEnrolled:hubPermission.enrolled];
    [self setAdmin:hubPermission.admin];
    [self setPending:hubPermission.pending];
    [self setContentVisible:hubPermission.contentVisible];
}

@end
