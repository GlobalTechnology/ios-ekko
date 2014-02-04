//
//  CoursesXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/3/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoursesXMLParser.h"

@implementation CoursesXMLParser

-(id)initWithData:(NSData *)data courseCallback:(Course *(^)(NSString *))callback {
    self = [super initWithData:data];
    if (!self) {
        return nil;
    }

    self.courseCallback = callback;

    return self;
}

@end
