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

typedef NS_ENUM(NSUInteger, EkkoEntityType) {
    EkkoEntityCourse,
    EkkoEntityAnswer,
    EkkoEntityPermission,
};

@interface DataManager : NSObject

+(DataManager *)sharedManager;

-(NSManagedObjectContext *)mainQueueManagedObjectContext;
-(NSManagedObjectContext *)newPrivateQueueManagedObjectContext;

-(NSString *)nameForEntity:(EkkoEntityType)entity;
-(NSEntityDescription *)entityDescriptionForEntity:(EkkoEntityType)entity;
-(NSManagedObject *)insertNewObjectForEntity:(EkkoEntityType)entity inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSFetchRequest *)fetchRequestForEntity:(EkkoEntityType)entity;

-(BOOL)saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
