//
//  Course.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractCourse.h"


@interface Course : AbstractCourse

@property (nonatomic) BOOL accessible;
@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorUrl;
@property (nonatomic, retain) NSString * courseCopyright;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic) NSTimeInterval lastSynced;

@end
