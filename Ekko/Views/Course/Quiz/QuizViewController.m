//
//  QuizViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "QuizViewController.h"

@implementation QuizViewController
@synthesize contentItem = _contentItem;

+(UIViewController<ContentItemProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard {
    return (UIViewController<ContentItemProtocol> *)[storyboard instantiateViewControllerWithIdentifier:@"quizViewController"];
}

-(Quiz *)quiz {
    return (Quiz *)self.contentItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.propogateSwipeOnNil = YES;
    
    if (self.quiz) {
        self.quiz.showAnswers = NO;
        UIViewController *questionViewController = [self.quiz questionViewControllerAtIndex:0 storyboard:self.storyboard];
        if (questionViewController) {
            [self setViewController:questionViewController direction:SwipeViewControllerDirectionNone];
            self.dataSource = self.quiz;
        }
    }
}

@end
