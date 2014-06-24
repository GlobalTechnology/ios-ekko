//
//  Course+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course+Ekko.h"
#import "Permission.h"

#import <TheKeyOAuth2Client.h>

@implementation Course (Ekko)

-(CourseEnrollmentType)enrollmentType {
    return (CourseEnrollmentType)[self.internalEnrollmentType unsignedIntegerValue];
}

-(void)setEnrollmentType:(CourseEnrollmentType)enrollmentType {
    [self setInternalEnrollmentType:[NSNumber numberWithUnsignedInteger:enrollmentType]];
}

+(NSSet *)keyPathsForValuesAffectingEnrollmentType {
    return [NSSet setWithObject:@"internalEnrollmentType"];
}

-(BOOL)isPublic {
    return [self.publicCourse boolValue];
}

-(void)setPublic:(BOOL)value {
    self.publicCourse = [NSNumber numberWithBool:value];
}

-(Permission *)permissionForGUID:(NSString *)guid {
    guid = guid ?: [TheKeyOAuth2Client sharedOAuth2Client].guid;
    for (Permission *permission in self.permissions) {
        if ([permission.guid compare:guid options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return permission;
        }
    }
    return nil;
}

-(Permission *)permission {
    return [self permissionForGUID:nil];
}

-(Resource *)bannerResource {
    if (self.bannerId && self.banner) {
        return [[Resource alloc] initWithBanner:self.banner];
    }
    return nil;
}

@end
