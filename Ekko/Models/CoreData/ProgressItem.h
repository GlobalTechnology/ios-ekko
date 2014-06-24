//
//  ProgressItem.h
//  Ekko
//
//  Created by Brian Zoetewey on 3/25/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProgressItem : NSManagedObject

@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * contentId;

@end
