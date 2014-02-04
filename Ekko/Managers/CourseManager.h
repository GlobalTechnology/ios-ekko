//
//  CourseManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Course.h"

typedef NS_ENUM(NSUInteger, EkkoCoursesFetchType) {
    EkkoAllCoursesFetchType,
    EkkoMyCoursesFetchType,
};

FOUNDATION_EXPORT NSString *const EkkoCourseManagerWillSyncCoursesNotification;
FOUNDATION_EXPORT NSString *const EkkoCourseManagerDidSyncCoursesNotification;

@interface CourseManager : NSObject

@property (nonatomic, strong, readonly) NSString *guid;

+(CourseManager *)sharedManager;

#pragma mark - Ekko Cloud
-(BOOL)isSyncInProgress;

#pragma mark - Hub
-(void)syncCourses;
//-(void)syncCourse:(NSString *)courseId complete:(void (^)())complete;

#pragma mark - CoreData
-(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark - NSFetchedResultsController
-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type;

#pragma mark - Course Enrollment
-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete;
-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete;

#pragma mark - My Courses Visibility
-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete;
-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete;


@end
