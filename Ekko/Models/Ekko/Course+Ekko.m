//
//  Course+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course+Ekko.h"

@implementation Course (Ekko)

-(CourseEnrollmentType)enrollmentType {
    return (CourseEnrollmentType)[self internalEnrollmentType];
}

-(void)setEnrollmentType:(CourseEnrollmentType)enrollmentType {
    [self setInternalEnrollmentType:(int16_t)enrollmentType];
}

+(NSSet *)keyPathsForValuesAffectingEnrollmentType {
    return [NSSet setWithObject:@"internalEnrollmentType"];
}

@end
