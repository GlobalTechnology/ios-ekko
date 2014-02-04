//
//  Banner.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Banner : NSManagedObject

@property (nonatomic) int16_t internalProvider;
@property (nonatomic) int16_t internalType;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * refId;
@property (nonatomic, retain) NSString * resourceId;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic) int64_t size;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) Course *course;

@end
