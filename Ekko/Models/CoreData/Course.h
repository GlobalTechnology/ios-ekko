//
//  Course.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Banner, Permission;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorUrl;
@property (nonatomic, retain) NSString * courseCopyright;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic) int16_t internalEnrollmentType;
@property (nonatomic) BOOL publicCourse;
@property (nonatomic, retain) Banner *banner;
@property (nonatomic, retain) Permission *permission;

@end
