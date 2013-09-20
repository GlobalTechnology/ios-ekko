//
//  ContentItem.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Manifest;

@interface ContentItem : NSManagedObject

@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * itemTitle;
@property (nonatomic, retain) Manifest *course;

@end
