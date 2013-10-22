//
//  CourseParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/22/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLParser.h"
#import "HubCourse.h"

@interface CourseParser : HubXMLParser

@property (nonatomic, strong) HubCourse *course;

@end
