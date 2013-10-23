//
//  Course+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course.h"
#import "CourseIdProtocol.h"

typedef NS_ENUM(int16_t, CourseEnrollmentType) {
    CourseEnrollmentUnknown  = 0,
    CourseEnrollmentDisabled = 1,
    CourseEnrollmentOpen     = 2,
    CourseEnrollmentApproval = 3,
};

@interface Course (Ekko) <CourseIdProtocol>

@property CourseEnrollmentType enrollmentType;

@end
