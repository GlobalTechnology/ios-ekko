//
//  HubSyncService.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubClient.h"

FOUNDATION_EXPORT NSString *const EkkoHubSyncServiceCoursesSyncBegin;
FOUNDATION_EXPORT NSString *const EkkoHubSyncServiceCoursesSyncEnd;

@interface HubSyncService : NSObject<HubClientCoursesDelegate, HubClientManifestDelegate>

+(HubSyncService *)sharedService;

-(void)syncCourses;
-(BOOL)coursesSyncInProgress;

-(void)syncManifest:(NSString *)courseId;

@end
