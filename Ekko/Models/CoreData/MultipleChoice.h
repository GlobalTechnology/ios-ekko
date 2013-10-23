//
//  MultipleChoice.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Question.h"

@class MultipleChoiceOption;

@interface MultipleChoice : Question

@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSOrderedSet *options;
@end

@interface MultipleChoice (CoreDataGeneratedAccessors)

- (void)insertObject:(MultipleChoiceOption *)value inOptionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromOptionsAtIndex:(NSUInteger)idx;
- (void)insertOptions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeOptionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInOptionsAtIndex:(NSUInteger)idx withObject:(MultipleChoiceOption *)value;
- (void)replaceOptionsAtIndexes:(NSIndexSet *)indexes withOptions:(NSArray *)values;
- (void)addOptionsObject:(MultipleChoiceOption *)value;
- (void)removeOptionsObject:(MultipleChoiceOption *)value;
- (void)addOptions:(NSOrderedSet *)values;
- (void)removeOptions:(NSOrderedSet *)values;
@end
