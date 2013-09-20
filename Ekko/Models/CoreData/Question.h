//
//  Question.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quiz;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSString * questionId;
@property (nonatomic, retain) NSString * questionType;
@property (nonatomic, retain) Quiz *quiz;

@end
