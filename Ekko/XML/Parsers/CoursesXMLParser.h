//
//  CoursesXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoXMLParser.h"

#import "Course+XMLModel.h"

@interface CoursesXMLParser : EkkoXMLParser

@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, copy) Course* (^courseCallback)(NSString *courseId);

-(id)initWithData:(NSData *)data courseCallback:(Course *(^)(NSString *courseId))callback;

@end
