//
//  Answer.h
//  Ekko
//
//  Created by Brian Zoetewey on 3/25/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * guid;

@end
