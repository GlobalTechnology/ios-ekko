//
//  ProgressManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 3/19/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest.h"
#import "Lesson.h"

FOUNDATION_EXPORT NSString *const EkkoProgressManagerDidUpdateProgressNotification;

@interface Progress : NSObject
@property (nonatomic) NSUInteger complete;
@property (nonatomic) NSUInteger total;
-(float)progress;
@end

@interface ProgressManager : NSObject

@property (nonatomic, strong, readonly) NSString *guid;

#pragma mark - Manager Access
+(ProgressManager *)progressManagerForGUID:(NSString *)guid;
+(ProgressManager *)progressManager;

#pragma mark - Get Progress
-(void)progressForCourseId:(NSString *)courseId progress:(void(^)(Progress *progress))progressBlock;
-(void)progressForCourse:(Manifest *)manifest progress:(void(^)(Progress *progress))progressBlock;
-(void)progressForLesson:(Lesson *)lesson progress:(void(^)(Progress *progress))progressBlock;

#pragma mark - Record Progress
-(void)recordProgress:(NSString *)contentId inCourse:(NSString *)courseId;

@end

@protocol ProgressItems <NSObject>
@required
-(NSMutableSet *)progressItems;
@end
