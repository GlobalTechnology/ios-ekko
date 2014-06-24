//
//  CoursesXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoreDataXMLParser.h"

@protocol CoursesXMLParserDelegate;

@interface CoursesXMLParser : CoreDataXMLParser

@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger limit;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, strong, readonly) NSMutableSet *resources;
@property (nonatomic, weak) id<CoursesXMLParserDelegate> courseDelegate;

-(id)initWithData:(NSData *)data managedObjectContext:(NSManagedObjectContext *)managedObjectContext delegate:(id<CoursesXMLParserDelegate>)delegate;

@end

@protocol CoursesXMLParserDelegate <NSObject>

@required
-(void)foundCourse:(NSString *)courseId isNewVersion:(BOOL)isNewVersion;

@end
