//
//  Banner.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Banner : NSManagedObject

@property (nonatomic, retain) NSNumber * internalType;
@property (nonatomic, retain) NSString * videoId;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSNumber * internalProvider;
@property (nonatomic, retain) NSString * bannerId;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * refId;
@property (nonatomic, retain) Course *course;

@end
