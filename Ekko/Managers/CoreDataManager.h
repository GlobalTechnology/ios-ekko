//
//  CoreDataManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EkkoEntityType) {
    EkkoEntityCourse,
    EkkoEntityAnswer,
    EkkoEntityPermission,
    EkkoEntityBanner,
};

@interface CoreDataManager : NSObject

+(CoreDataManager *)sharedManager;

-(NSManagedObjectContext *)mainQueueManagedObjectContext;
-(NSManagedObjectContext *)newPrivateQueueManagedObjectContext;

-(NSString *)nameForEntity:(EkkoEntityType)entity;
-(NSEntityDescription *)entityDescriptionForEntity:(EkkoEntityType)entity;
-(NSManagedObject *)insertNewObjectForEntity:(EkkoEntityType)entity inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSFetchRequest *)fetchRequestForEntity:(EkkoEntityType)entity;

-(BOOL)saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
