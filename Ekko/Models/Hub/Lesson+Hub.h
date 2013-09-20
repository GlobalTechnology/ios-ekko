//
//  Lesson+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Lesson.h"
#import "HubLesson.h"

@interface Lesson (Hub)

-(void)updateWithHubLesson:(HubLesson *)hubLesson;

@end
