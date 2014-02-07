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

-(Resource *)banner {
    Resource *resource = [[Resource alloc] init];
    resource.resourceId = self.bannerId;
    resource.courseId   = self.courseId;
    resource.type       = EkkoResourceTypeFile;
    resource.sha1       = self.bannerSha1;
    resource.size       = [self.bannerSize unsignedLongLongValue];
    resource.mimeType   = self.bannerMimeType;
    return resource;
}

@end
