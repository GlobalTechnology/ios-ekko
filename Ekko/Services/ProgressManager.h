//
//  ProgressManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgressManagerDataSource;
@protocol ProgressManagerDelegate;

@interface ProgressManager : NSObject
+(ProgressManager *)progressManager;
+(void)setItemComplete:(NSString *)itemId forCourse:(NSString *)courseId;

-(void)addProgressDelegate:(id<ProgressManagerDelegate>)delegate forDataSource:(id<ProgressManagerDataSource>)dataSource;
-(void)removeProgressDelegate:(id<ProgressManagerDelegate>)delegate;
-(void)removeProgressDelegate:(id<ProgressManagerDelegate>)delegate andDataSource:(id<ProgressManagerDataSource>)dataSource;
@end

@protocol ProgressManagerDataSource <NSObject>
@required
-(NSSet *)progressItemIds;
-(NSString *)courseId;
@end

@protocol ProgressManagerDelegate <NSObject>
@required
-(void)progressUpdateFor:(id<ProgressManagerDataSource>)dataSource currentProgress:(float)progress;
@end