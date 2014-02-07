//
//  CoursesXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoXMLParser.h"

#import "Course+XMLModel.h"

@protocol CoursesXMLParserDelegate;

@interface CoursesXMLParser : EkkoXMLParser

@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, weak) id<CoursesXMLParserDelegate> courseDelegate;

@property (nonatomic, strong, readonly) NSMutableSet *resources;

-(id)initWithData:(NSData *)data andDelegate:(id<CoursesXMLParserDelegate>)delegate;

@end

@protocol CoursesXMLParserDelegate <NSObject>
@required
-(void)foundCourse:(NSString *)courseId;
-(Course *)fetchCourse:(NSString *)courseId;
-(Permission *)newPermission;
@end