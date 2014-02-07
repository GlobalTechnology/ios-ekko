//
//  Lesson.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/4/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson

@synthesize media    = _media;
@synthesize pages    = _pages;

-(NSString *)lessonId {
    return self.contentId;
}

-(void)setLessonId:(NSString *)lessonId {
    self.contentId = lessonId;
}

-(EkkoContentType)contentType {
    return EkkoContentTypeLesson;
}

-(NSMutableOrderedSet *)media {
    if (!_media) {
        _media = [NSMutableOrderedSet orderedSet];
    }
    return _media;
}

-(NSMutableOrderedSet *)pages {
    if (!_pages) {
        _pages = [NSMutableOrderedSet orderedSet];
    }
    return _pages;
}

@end
