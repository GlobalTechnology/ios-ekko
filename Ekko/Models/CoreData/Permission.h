//
//  Permission.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Permission : NSManagedObject

@property (nonatomic) BOOL admin;
@property (nonatomic) BOOL contentVisible;
@property (nonatomic) BOOL enrolled;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic) BOOL hidden;
@property (nonatomic) BOOL pending;
@property (nonatomic, retain) Course *course;

@end
