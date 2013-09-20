//
//  Quiz+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Quiz+Ekko.h"
#import "QuizViewController.h"

#import "MultipleChoice.h"
#import "MultipleChoiceViewController.h"

@implementation Quiz (Ekko)

-(void)setQuizId:(NSString *)quizId {
    [self setItemId:quizId];
}

-(NSString *)quizId {
    return [self quizId];
}

-(void)setQuizTitle:(NSString *)quizTitle {
    [self setItemTitle:quizTitle];
}

-(NSString *)quizTitle {
    return [self itemTitle];
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
    return nil;
}


-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(QuizProtocol)]) {
        NSUInteger index = [self indexOfQuestionViewController:(UIViewController<QuizProtocol> *)viewController];
        if (index == NSNotFound) {
            return nil;
        }
        index++;
        if (index >= [self.questions count]) {
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
        [questionViewController setTitle:self.quizTitle];
    }
    return questionViewController;
}

@end
