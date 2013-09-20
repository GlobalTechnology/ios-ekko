//
//  Resource.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AbstractCourse;

@interface Resource : NSManagedObject

@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * resourceId;
@property (nonatomic) int16_t resourceProvider;
@property (nonatomic) int16_t resourceType;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic) int64_t size;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) AbstractCourse *course;

@end
