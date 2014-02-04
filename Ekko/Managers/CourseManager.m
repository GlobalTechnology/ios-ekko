//
//  CourseManager.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CourseManager.h"

#import "EkkoCloudClient.h"
#import "DataManager.h"
#import "CoursesXMLParser.h"

NSString *const EkkoCourseManagerWillSyncCoursesNotification = @"EkkoCourseManagerWillSyncCoursesNotification";
NSString *const EkkoCourseManagerDidSyncCoursesNotification = @"EkkoCourseManagerDidSyncCoursesNotification";

@interface CourseManager ()
@property (atomic) BOOL syncInProgress;
@property (nonatomic, strong) NSManagedObjectContext *syncContext;
@end

@implementation CourseManager

+(CourseManager *)sharedManager {
    __strong static CourseManager *_manager = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _manager = [[CourseManager alloc] init];
    });
    return _manager;
}

-(BOOL)isSyncInProgress {
    return self.syncInProgress;
}

-(void)syncCourses {
    if (self.syncInProgress) {
        return;
    }
    self.syncInProgress = YES;
    self.syncContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];

    [self getCoursesStaringAt:0 limit:5];
}

-(void)getCoursesStaringAt:(NSInteger)start limit:(NSInteger)limit {
    [[EkkoCloudClient sharedClient] getCoursesStartingAt:start withLimit:limit completeBlock:^(NSData *coursesData, NSError *error) {
        if (coursesData) {
            [self.syncContext performBlock:^{
                CoursesXMLParser *parser = [[CoursesXMLParser alloc] initWithData:coursesData courseCallback:^Course *(NSString *courseId) {
                    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
                    NSArray *results = [self.syncContext executeFetchRequest:request error:nil];
                    if (results && results.count > 0) {
                        return (Course *)[results firstObject];
                    }
                    return (Course *)[[DataManager sharedManager] insertNewObjectForEntity:EkkoEntityCourse inManagedObjectContext:self.syncContext];
                }];
                [parser parse];
                if (parser.hasMore) {
                    NSInteger start = parser.start + parser.limit;
                    [self getCoursesStaringAt:start limit:parser.limit];
                }
                else {
                    [[DataManager sharedManager] saveManagedObjectContext:self.syncContext];
                }
            }];
        }
    }];
}














-(Course *)getCourseById:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setPredicate:[NSPredicate predicateWithFormat:@"courseId == %@", courseId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (results && results.count > 0) {
        return (Course *)[results firstObject];
    }
    return nil;
}

-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    NSArray *courses = [managedObjectContext executeFetchRequest:request error:nil];
    if (courses != nil) {
        return courses;
    }
    return [NSArray array];
}

-(NSFetchedResultsController *)fetchedResultsControllerForType:(EkkoCoursesFetchType)type {
    NSFetchRequest *request = [[DataManager sharedManager] fetchRequestForEntity:EkkoEntityCourse];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseTitle" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]]];

    switch (type) {
        case EkkoMyCoursesFetchType:
            [request setPredicate:[NSPredicate predicateWithFormat:@"permission.guid LIKE[c] %@ AND permission.contentVisible == YES AND permission.hidden == NO", [[EkkoCloudClient sharedClient] guid] ?: @"GUEST"]];
            break;
        case EkkoAllCoursesFetchType:
        default:
            [request setPredicate:[NSPredicate predicateWithFormat:@"permission.guid LIKE[c] %@", [[EkkoCloudClient sharedClient] guid] ?: @"GUEST"]];
            break;
    }
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[DataManager sharedManager] mainQueueManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

-(void)enrollInCourse:(NSString *)courseId complete:(void (^)())complete {
    [[EkkoCloudClient sharedClient] enrollInCourse:courseId completeBlock:^(NSData *courseData, NSError *error) {
        //TODO Fix me
    }];
}

-(void)unenrollFromCourse:(NSString *)courseId complete:(void (^)())complete {
/*
    [[EkkoCloudClient sharedClientForGUID:[TheKeyOAuth2Client sharedOAuth2Client].guid] unenrollFromCourse:courseId callback:^(HubCourse *hubCourse) {
        [self updateCourse:courseId withHubCourse:hubCourse complete:^{
            if (complete) {
                complete();
            }
        }];
    }];
*/
}

-(void)showCourseInMyCourses:(NSString *)courseId complete:(void (^)())complete {
/*
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        [course.permission setHidden:NO];
        course.permission = course.permission;
        [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        if (complete != nil) {
            complete();
        }
    }];
*/
}

-(void)hideCourseFromMyCourses:(NSString *)courseId complete:(void (^)())complete {
/*
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] newPrivateQueueManagedObjectContext];
    [managedObjectContext performBlock:^{
        Course *course = [self getCourseById:courseId withManagedObjectContext:managedObjectContext];
        [course.permission setHidden:YES];
        course.permission = course.permission;
        [[DataManager sharedManager] saveManagedObjectContext:managedObjectContext];
        if (complete != nil) {
            complete();
        }
    }];
*/
}

@end
