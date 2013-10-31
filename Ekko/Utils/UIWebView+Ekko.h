//
//  UIWebView+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/31/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Ekko)

-(void)loadLessonPageString:(NSString *)string;
-(void)loadCourseCompleteString:(NSString *)string;
-(void)loadQuizQuestionString:(NSString *)string;
-(void)loadQuizResultsString:(NSString *)label total:(NSUInteger)total correct:(NSUInteger)correct;

@end
