//
//  URLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 6/27/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, strong) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end
