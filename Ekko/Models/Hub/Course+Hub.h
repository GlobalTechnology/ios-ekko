//
//  Course+Hub.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/6/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Course.h"
#import "HubCourse.h"

@interface Course (Hub)

-(void)syncWithHubCourse:(HubCourse *)hubCourse;

@end
