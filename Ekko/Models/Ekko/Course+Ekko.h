//
//  Course+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course.h"
#import "Resource.h"

typedef NS_ENUM(NSUInteger, CourseEnrollmentType) {
    CourseEnrollmentUnknown  = 0,
    CourseEnrollmentDisabled = 1,
    CourseEnrollmentOpen     = 2,
    CourseEnrollmentApproval = 3,
};

typedef NS_OPTIONS (NSUInteger, CourseActions) {
    CourseActionNone     = 0,
    CourseActionEnroll   = 1 << 0,
    CourseActionUnenroll = 1 << 1,
    CourseActionRequest  = 1 << 2,
    CourseActionShow     = 1 << 3,
    CourseActionHide     = 1 << 4,
};

@interface Course (Ekko)

@property (nonatomic) CourseEnrollmentType enrollmentType;
@property (nonatomic, getter = isPublic) BOOL public;
@property (nonatomic, readonly) Permission *permission;

-(Permission *)permissionForGUID:(NSString *)guid;
-(Resource *)bannerResource;

-(CourseActions)courseActions;

@end
