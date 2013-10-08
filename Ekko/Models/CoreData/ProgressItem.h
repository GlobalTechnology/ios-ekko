//
//  ProgressItem.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/7/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProgressItem : NSManagedObject

@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * itemId;

@end
