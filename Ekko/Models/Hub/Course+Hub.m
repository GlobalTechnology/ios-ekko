//
//  Course+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/6/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course+Hub.h"
#import "Course+Ekko.h"
#import "Permission+Hub.h"
#import "Resource+Hub.h"

#import "DataManager.h"

@implementation Course (Hub)

-(void)syncWithHubCourse:(HubCourse *)hubCourse {
    [self setCourseId:[hubCourse courseId]];
    [self setCourseVersion:[hubCourse courseVersion]];
    [self setPublicCourse:[hubCourse courseIsPublic]];

    if ([hubCourse.enrollmentType isEqualToString:kEkkoHubXMLValueEnrollmentTypeDisabled])
        [self setEnrollmentType:CourseEnrollmentDisabled];
    else if ([hubCourse.enrollmentType isEqualToString:kEkkoHubXMLValueEnrollmentTypeOpen])
        [self setEnrollmentType:CourseEnrollmentOpen];
    else if ([hubCourse.enrollmentType isEqualToString:kEkkoHubXMLValueEnrollmentTypeApproval])
        [self setEnrollmentType:CourseEnrollmentApproval];
    else
        [self setEnrollmentType:CourseEnrollmentUnknown];

    HubMeta *hubMeta = [hubCourse courseMeta];
    [self setCourseTitle:[hubMeta courseTitle]];
    [self setCourseDescription:[hubMeta courseDescription]];
    [self setAuthorName:[hubMeta authorName]];
    [self setAuthorEmail:[hubMeta authorEmail]];
    [self setAuthorUrl:[hubMeta authorUrl]];
    [self setCourseCopyright:[hubMeta courseCopyright]];

    HubPermission *hubPermission = [hubCourse permission];
    if (hubPermission) {
        if (self.permission == nil) {
            [self setPermission:(Permission *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityPermission inManagedObjectContext:self.managedObjectContext]];
        }
        [self.permission syncWithHubPermission:hubPermission];
    }
    else
        [self setPermission:nil];

    HubResource *hubResource = [hubCourse bannerResource];
    if (hubResource) {
        if (self.banner == nil) {
            [self setBanner:(CourseResource *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourseResource inManagedObjectContext:self.managedObjectContext]];
        }
        [(Resource *)self.banner syncWithHubResource:hubResource];
    }
    else
        [self setBanner:nil];
}

@end
