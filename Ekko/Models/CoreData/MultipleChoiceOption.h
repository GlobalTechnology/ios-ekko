//
//  MultipleChoiceOption.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MultipleChoice;

@interface MultipleChoiceOption : NSManagedObject

@property (nonatomic) BOOL isAnswer;
@property (nonatomic, retain) NSString * optionId;
@property (nonatomic, retain) NSString * optionText;
@property (nonatomic, retain) MultipleChoice *question;

@end
