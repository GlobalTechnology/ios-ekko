//
//  Quiz+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Quiz.h"
#import "ContentItem.h"
#import "SwipeViewController.h"
#import "QuizProtocol.h"

@interface Quiz (Ekko) <SwipeViewControllerDataSource>

@property (nonatomic) BOOL showAnswers;

-(UIViewController<QuizProtocol> *)questionViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
-(NSUInteger)indexOfQuestionViewController:(UIViewController<QuizProtocol> *)questionViewController;

@end
