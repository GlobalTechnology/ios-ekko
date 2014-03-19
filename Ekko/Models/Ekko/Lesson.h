//
//  Lesson.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ContentItem.h"

@interface Lesson : ContentItem

@property (nonatomic, strong) NSString *lessonId;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *media;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *pages;

@end
