//
//  Manifest.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AbstractCourse.h"

@class ContentItem;

@interface Manifest : AbstractCourse

@property (nonatomic, retain) NSString * authorEmail;
@property (nonatomic, retain) NSString * authorName;
@property (nonatomic, retain) NSString * authorUrl;
@property (nonatomic, retain) NSString * courseCopyright;
@property (nonatomic, retain) NSString * courseDescription;
@property (nonatomic, retain) NSString * courseTitle;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic) NSTimeInterval lastSynced;
@property (nonatomic, retain) NSString * completeMessage;
@property (nonatomic, retain) NSOrderedSet *content;
@end

@interface Manifest (CoreDataGeneratedAccessors)

- (void)insertObject:(ContentItem *)value inContentAtIndex:(NSUInteger)idx;
- (void)removeObjectFromContentAtIndex:(NSUInteger)idx;
- (void)insertContent:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeContentAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInContentAtIndex:(NSUInteger)idx withObject:(ContentItem *)value;
- (void)replaceContentAtIndexes:(NSIndexSet *)indexes withContent:(NSArray *)values;
- (void)addContentObject:(ContentItem *)value;
- (void)removeContentObject:(ContentItem *)value;
- (void)addContent:(NSOrderedSet *)values;
- (void)removeContent:(NSOrderedSet *)values;
@end
