//
//  Quiz.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ContentItem.h"

@class Question;

@interface Quiz : ContentItem

@property (nonatomic, retain) NSOrderedSet *questions;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)insertObject:(Question *)value inQuestionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQuestionsAtIndex:(NSUInteger)idx;
- (void)insertQuestions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQuestionsAtIndex:(NSUInteger)idx withObject:(Question *)value;
- (void)replaceQuestionsAtIndexes:(NSIndexSet *)indexes withQuestions:(NSArray *)values;
- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSOrderedSet *)values;
- (void)removeQuestions:(NSOrderedSet *)values;
@end
