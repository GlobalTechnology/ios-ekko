//
//  Quiz+View.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Quiz+View.h"
#import "QuizViewController.h"

#import "QuizCompleteViewController.h"
#import "MultipleChoice.h"
#import "MultipleChoiceViewController.h"
#import <objc/runtime.h>

static NSString *const kEkkoQuizShowAnswersProperty = @"kEkkoQuizShowAnswersProperty";

@implementation Quiz (View)

-(void)setShowAnswers:(BOOL)showAnswers {
    NSNumber *number = [NSNumber numberWithBool:showAnswers];
    objc_setAssociatedObject(self, &kEkkoQuizShowAnswersProperty, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)showAnswers {
    NSNumber *number = objc_getAssociatedObject(self, &kEkkoQuizShowAnswersProperty);
    return [number boolValue];
}

-(QuizCompleteViewController *)quizCompleteViewControllerFromStoryboard:(UIStoryboard *)storyboard {
    QuizCompleteViewController *quizCompleteViewController = [storyboard instantiateViewControllerWithIdentifier:@"quizCompleteViewController"];
    [quizCompleteViewController setQuiz:self];
    return quizCompleteViewController;
}

-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(QuizProtocol)]) {
        NSUInteger index = [self indexOfQuestionViewController:(UIViewController<QuizProtocol> *)viewController];
        if (index == NSNotFound || index == 0) {
            return nil;
        }
        index--;
        return [self questionViewControllerAtIndex:index storyboard:viewController.storyboard];
    }
    else if ([viewController isKindOfClass:[QuizCompleteViewController class]]) {
        NSUInteger index = [self.questions count] - 1;
        if (index <= 0) {
            return nil;
        }
        return [self quizCompleteViewControllerFromStoryboard:viewController.storyboard];
    }
    return nil;
}

-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(QuizProtocol)]) {
        NSUInteger index = [self indexOfQuestionViewController:(UIViewController<QuizProtocol> *)viewController];
        if (index == NSNotFound) {
            return nil;
        }
        index++;
        if (index == [self.questions count]) {
            return [self quizCompleteViewControllerFromStoryboard:viewController.storyboard];
        }
        else if (index >= [self.questions count]) {
            return nil;
        }
        return [self questionViewControllerAtIndex:index storyboard:viewController.storyboard];
    }
    return nil;
}

-(NSUInteger)indexOfQuestionViewController:(UIViewController<QuizProtocol> *)questionViewController {
    return [self.questions indexOfObject:questionViewController.question];
}

-(UIViewController<QuizProtocol> *)questionViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (([self.questions count] == 0) || (index >= [self.questions count])) {
        return nil;
    }
    
    Question *question = [self.questions objectAtIndex:index];
    UIViewController<QuizProtocol> *questionViewController;
    if ([question isKindOfClass:[MultipleChoice class]]) {
        questionViewController = [storyboard instantiateViewControllerWithIdentifier:@"multipleChoiceViewController"];
    }
    if (questionViewController) {
        [questionViewController setQuestion:question];
    }
    return questionViewController;
}

@end
