//
//  Media.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lesson;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSString * mediaId;
@property (nonatomic, retain) NSString * mediaType;
@property (nonatomic, retain) NSString * resourceId;
@property (nonatomic, retain) NSString * thumbnailId;
@property (nonatomic, retain) Lesson *lesson;

@end
