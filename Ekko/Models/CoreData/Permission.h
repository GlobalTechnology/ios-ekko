//
//  Permission.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Permission : NSManagedObject

@property (nonatomic, retain) NSString * guid;
@property (nonatomic) BOOL enrolled;
@property (nonatomic) BOOL admin;
@property (nonatomic) BOOL pending;
@property (nonatomic) BOOL contentVisible;
@property (nonatomic, retain) Course *course;

@end
