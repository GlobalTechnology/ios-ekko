//
//  CourseManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Course.h"
#import "CoursesXMLParser.h"

typedef NS_ENUM(NSUInteger, EkkoCoursesFetchType) {
    EkkoAllCoursesFetchType,
    EkkoMyCoursesFetchType,
};

FOUNDATION_EXPORT NSString *const EkkoCourseManagerWillSyncCoursesNotification;
FOUNDATION_EXPORT NSString *const EkkoCourseManagerDidSyncCoursesNotification;

@interface CourseManager : NSObject <CoursesXMLParserDelegate>

@property (nonatomic, strong, readonly) NSString *guid;

+(CourseManager *)courseManagerForGUID:(NSString *)guid;

#pragma mark - Sync
-(BOOL)isSyncInProgress;
+(void)syncCoursesForGUID:(NSString *)guid;
-(void)syncCourses;
-(void)syncCourse:(NSString *)courseId completeBlock:(void (^)())complete;

#pragma mark - Core Data
+(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark - Enrollment
-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete;
-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete;

#pragma mark - Visibility
-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete;
-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete;

#pragma mark - NSFetchedResultsController
-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type;

@end
