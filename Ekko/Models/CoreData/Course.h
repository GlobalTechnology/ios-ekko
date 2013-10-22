//
//  Course.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractCourse.h"

@class Permission;

@interface Course : AbstractCourse

@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorUrl;
@property (nonatomic, retain) NSString * courseCopyright;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic) int16_t internalEnrollmentType;
@property (nonatomic) NSTimeInterval lastSynced;
@property (nonatomic) BOOL publicCourse;
@property (nonatomic, retain) Permission *permission;

@end
