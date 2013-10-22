//
//  Course+Hub.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/6/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course+Hub.h"
#import "Course+Ekko.h"
#import "DataManager.h"
#import "Permission+Hub.h"
#import "Resource+Hub.h"

@implementation Course (Hub)

-(void)updateWithHubCourse:(HubCourse *)hubCourse {
    //Update Course if it is a new object or version number has changed
    if ([[self objectID] isTemporaryID] || [hubCourse courseVersion] > [self courseVersion]) {
        //Update Last Synced to NOW
        [self setLastSynced:[[NSDate date] timeIntervalSince1970]];
        
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
                [self setPermission:(Permission *)[[DataManager dataManager] insertNewObjectForEntity:EkkoPermissionEntity inManagedObjectContext:self.managedObjectContext]];
            }
            [self.permission syncFromHubPermission:hubPermission];
        }
        
        [self setResources:[NSMutableSet set]];
        HubResource *hubResource = [hubCourse bannerResource];
        if (hubResource) {
            Resource *resource = (Resource *)[[DataManager dataManager] insertNewObjectForEntity:EkkoResourceEntity inManagedObjectContext:self.managedObjectContext];
            [resource updateFromHubResource:hubResource];
            [self addResourcesObject:resource];
        }
    }
}

@end
