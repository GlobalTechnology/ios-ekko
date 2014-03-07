//
//  CourseXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoreDataXMLParser.h"

#import "Course+XMLModel.h"

@interface CourseXMLParser : CoreDataXMLParser

@property (nonatomic, getter = isNewVersion) BOOL newVersion;
@property (nonatomic, strong) Course *course;
@property (nonatomic, strong, readonly) NSMutableSet *resources;

@end
