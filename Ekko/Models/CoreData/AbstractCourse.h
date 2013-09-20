//
//  AbstractCourse.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Resource;

@interface AbstractCourse : NSManagedObject

@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSSet *resources;
@end

@interface AbstractCourse (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(Resource *)value;
- (void)removeResourcesObject:(Resource *)value;
- (void)addResources:(NSSet *)values;
- (void)removeResources:(NSSet *)values;

@end
