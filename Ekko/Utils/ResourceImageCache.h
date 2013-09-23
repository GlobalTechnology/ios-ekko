//
//  ResourceImageCache.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/19/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceImageCache : NSObject

@property (nonatomic, copy, readonly) NSString *courseId;

-(id)initWithCourseId:(NSString *)courseId;

-(NSString *)pathForKey:(NSString *)key;

-(void)imageForKey:(NSString *)key withCallback:(void (^)(UIImage *image))callback;
-(BOOL)imageExistsForKey:(NSString *)key;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(void)removeImageForKey:(NSString *)key;
-(void)removeAllImages;

@end
