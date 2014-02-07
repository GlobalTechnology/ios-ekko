//
//  Course+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course.h"
#import "CourseIdProtocol.h"
#import "Resource+Ekko.h"

typedef NS_ENUM(NSUInteger, CourseEnrollmentType) {
    CourseEnrollmentUnknown  = 0,
    CourseEnrollmentDisabled = 1,
    CourseEnrollmentOpen     = 2,
    CourseEnrollmentApproval = 3,
};

@interface Course (Ekko) <CourseIdProtocol>

@property (nonatomic) CourseEnrollmentType enrollmentType;
@property (nonatomic, getter = isPublic) BOOL public;
@property (nonatomic, readonly) Permission *permission;

-(Permission *)permissionForGUID:(NSString *)guid;
-(Resource *)bannerResource;

@end
