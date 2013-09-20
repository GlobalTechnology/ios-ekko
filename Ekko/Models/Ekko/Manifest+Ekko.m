//
//  Manifest+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Manifest+Ekko.h"

#import "UIColor+Ekko.h"

#import "LessonViewController.h"
#import "QuizViewController.h"

@implementation Manifest (Ekko)

-(Resource *)resourceByResourceId:(NSString *)resourceId {
    for (Resource *resource in self.resources) {
        if ([resource.resourceId isEqualToString:resourceId]) {
            return resource;
        }
    }
    return nil;
}

-(NSUInteger)indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController {
    if (viewController.contentItem) {
        return [self.content indexOfObject:viewController.contentItem];
    }
    return NSNotFound;
}

-(UIViewController<ContentItemProtocol> *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (([self.content count] == 0) || (index >= [self.content count])) {
        return nil;
    }
    ContentItem *contentItem = [self.content objectAtIndex:index];
    UIViewController<ContentItemProtocol> *contentViewController = nil;
    if ([contentItem isKindOfClass:[Lesson class]]) {
        contentViewController = [LessonViewController viewControllerWithStoryboard:storyboard];
    }
    else if ([contentItem isKindOfClass:[Quiz class]]) {
        contentViewController = [QuizViewController viewControllerWithStoryboard:storyboard];
    }
    if (contentViewController) {
        [contentViewController setContentItem:contentItem];
    }
    return contentViewController;
}


#pragma mark - SwipeViewControllerDataSource

-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ContentItemProtocol)]) {
        NSUInteger index = [self indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController];
        if (index == NSNotFound) {
            return nil;
        }
        index++;
        if (index >= [self.content count]) {
            return nil;
        }
        return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
    }
    return nil;
}

-(BOOL)swipeViewController:(SwipeViewController *)swipeViewController hasViewControllerAfterViewController:(UIViewController *)viewController {
    if (![viewController conformsToProtocol:@protocol(ContentItemProtocol)]) {
        return NO;
    }
    NSUInteger index = [self indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController];
    if (index == NSNotFound) {
        return NO;
    }
    index++;
    if (index >= [self.content count]) {
        return NO;
    }
    return YES;
}

-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController conformsToProtocol:@protocol(ContentItemProtocol)]) {
        NSUInteger index = [self indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController];
        if (index == NSNotFound || index == 0) {
            return nil;
        }
        index--;
        return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
    }
    return nil;
}

-(BOOL)swipeViewController:(SwipeViewController *)swipeViewController hasViewControllerBeforeViewController:(UIViewController *)viewController {
    if (![viewController conformsToProtocol:@protocol(ContentItemProtocol)]) {
        return NO;
    }
    NSUInteger index = [self indexOfViewController:(UIViewController<ContentItemProtocol> *)viewController];
    if (index == NSNotFound || index == 0) {
        return NO;
    }
    index--;
    return YES;
}

@end
