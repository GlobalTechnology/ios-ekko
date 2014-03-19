//
//  Course.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Banner, Permission;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * bannerId;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic, retain) NSNumber * courseVersion;
@property (nonatomic, retain) NSNumber * internalEnrollmentType;
@property (nonatomic, retain) NSNumber * publicCourse;
@property (nonatomic, retain) NSSet *permissions;
@property (nonatomic, retain) Banner *banner;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addPermissionsObject:(Permission *)value;
- (void)removePermissionsObject:(Permission *)value;
- (void)addPermissions:(NSSet *)values;
- (void)removePermissions:(NSSet *)values;

@end
