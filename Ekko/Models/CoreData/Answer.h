//
//  Answer.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answer : NSManagedObject

@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * courseId;
@property (nonatomic, retain) NSString * questionId;

@end
