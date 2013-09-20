//
//  CoreDataService.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/1/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Course+Hub.h"
#import "Manifest+hub.h"
#import "Resource+Hub.h"

#import "Lesson+Hub.h"
#import "Quiz+Hub.h"
#import "MultipleChoice.h"
#import "MultipleChoiceOption.h"

typedef NS_ENUM(NSUInteger, EkkoCoreDataEntity) {
    EkkoCoreDataEntityCourse,
    EkkoCoreDataEntityManifest,
    EkkoCoreDataEntityResource,
    EkkoCoreDataEntityLesson,
    EkkoCoreDataEntityQuiz,
    EkkoCoreDataEntityPage,
    EkkoCoreDataEntityMedia,
    EkkoCoreDataEntityMultipleChoice,
    EkkoCoreDataEntityMultipleChoiceOption,
};

@interface CoreDataService : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(CoreDataService *)sharedService;

-(NSURL *)applicationDocumentsDirectory;
-(void)saveContext;

-(NSManagedObject *)newObjectForEntityType:(EkkoCoreDataEntity)entityType;

#pragma mark - Course
-(Course *)newCourseObject;
-(NSArray *)getAllCourseObjects;
-(NSFetchedResultsController *)courseFetchedResultsController;

#pragma mark - Manifest
-(Manifest *)newManifestObject;
-(Manifest *)getManifestObjectByCourseId:(NSString *)courseId;

#pragma mark - Resource
-(Resource *)newResourceObject;

#pragma mark - Lesson
-(Lesson *)newLessonObject;

#pragma mark - Quiz
-(Quiz *)newQuizObject;

#pragma mark - Page
-(Page *)newPageObject;

#pragma mark - Media
-(Media *)newMediaObject;

#pragma mark - Question
-(MultipleChoice *)newMultipleChoiceObject;
-(MultipleChoiceOption *)newMultipleChoiceOptionObject;

@end
