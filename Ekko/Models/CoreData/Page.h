//
//  Page.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lesson;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * pageId;
@property (nonatomic, retain) NSString * pageText;
@property (nonatomic, retain) Lesson *lesson;

@end
