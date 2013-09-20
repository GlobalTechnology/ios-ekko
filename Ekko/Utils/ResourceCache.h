//
//  ResourceCache.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/19/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceCache : NSObject

@property (nonatomic, copy, readonly) NSString *courseId;

-(id)initWithCourseId:(NSString *)courseId;

-(NSString *)pathForKey:(NSString *)key;

-(void)objectForKey:(NSString *)key withCallback:(void (^)(id object))callback;
-(BOOL)objectExistsForKey:(NSString *)key;

-(void)setObject:(id)object forKey:(NSString *)key;
-(void)removeObjectForKey:(NSString *)key;
-(void)removeAllObjects;

@end
