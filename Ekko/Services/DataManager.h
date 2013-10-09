//
//  DataManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Manifest.h"
#import "Course.h"

typedef NS_ENUM(NSUInteger, EkkoEntity) {
    EkkoCourseEntity,
    EkkoManifestEntity,
    EkkoResourceEntity,
    EkkoLessonEntity,
    EkkoQuizEntity,
    EkkoPageEntity,
    EkkoMediaEntity,
    EkkoMultipleChoiceEntity,
    EkkoMultipleChoiceOptionEntity,
    EkkoProgressItemEntity,
};

@interface DataManager : NSObject

+(DataManager *)dataManager;

-(NSManagedObjectContext *)mainQueueManagedObjectContext;
-(NSManagedObjectContext *)newPrivateQueueManagedObjectContext;

-(NSString *)nameForEntity:(EkkoEntity)entity;
-(NSEntityDescription *)entityDescriptionForEntity:(EkkoEntity)entity;
-(NSManagedObject *)insertNewObjectForEntity:(EkkoEntity)entity inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSFetchRequest *)fetchRequestForEntity:(EkkoEntity)entity;

-(void)saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark - Manifest
-(Manifest *)insertNewManifestInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(Manifest *)getManifestByCourseId:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

#pragma mark - Course
-(Course *)insertNewCourseInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSArray *)getAllCoursesWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSFetchedResultsController *)coursesFetchedResultsController;

@end
