//
//  CoursesParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/5/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLParser.h"

@interface CoursesParser : HubXMLParser

@property (nonatomic) BOOL hasMore;
@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;
@property (readonly, strong, nonatomic) NSMutableArray *courses;

@end
