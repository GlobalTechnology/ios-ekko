//
//  Course.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseResource, Permission;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorUrl;
@property (nonatomic, retain) NSString * courseCopyright;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic) int16_t internalEnrollmentType;
@property (nonatomic) BOOL publicCourse;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) Permission *permission;
@property (nonatomic, retain) CourseResource *banner;

@end
