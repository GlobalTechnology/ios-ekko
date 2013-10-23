//
//  Lesson.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ContentItem.h"

@class Media, Page;

@interface Lesson : ContentItem

@property (nonatomic, retain) NSOrderedSet *media;
@property (nonatomic, retain) NSOrderedSet *pages;
@end

@interface Lesson (CoreDataGeneratedAccessors)

- (void)insertObject:(Media *)value inMediaAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMediaAtIndex:(NSUInteger)idx;
- (void)insertMedia:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMediaAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMediaAtIndex:(NSUInteger)idx withObject:(Media *)value;
- (void)replaceMediaAtIndexes:(NSIndexSet *)indexes withMedia:(NSArray *)values;
- (void)addMediaObject:(Media *)value;
- (void)removeMediaObject:(Media *)value;
- (void)addMedia:(NSOrderedSet *)values;
- (void)removeMedia:(NSOrderedSet *)values;
- (void)insertObject:(Page *)value inPagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPagesAtIndex:(NSUInteger)idx;
- (void)insertPages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPagesAtIndex:(NSUInteger)idx withObject:(Page *)value;
- (void)replacePagesAtIndexes:(NSIndexSet *)indexes withPages:(NSArray *)values;
- (void)addPagesObject:(Page *)value;
- (void)removePagesObject:(Page *)value;
- (void)addPages:(NSOrderedSet *)values;
- (void)removePages:(NSOrderedSet *)values;
@end
