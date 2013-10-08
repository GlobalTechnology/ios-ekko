//
//  Lesson+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Lesson+Ekko.h"
#import "Manifest+Ekko.h"

#import "LessonViewController.h"

@implementation Lesson (Ekko)

-(void)setLessonId:(NSString *)lessonId {
    [self setItemId:lessonId];
}

-(NSString *)lessonId {
    return [self itemId];
}

-(void)setLessonTitle:(NSString *)lessonTitle {
    [self setItemTitle:lessonTitle];
}

-(NSString *)lessonTitle {
    return [self itemTitle];
}

#pragma mark - SwipeViewControllerDataSource
-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PageViewController class]]) {
        return [self viewControllerBeforePageViewController:(PageViewController *)viewController];
    }
    else if ([viewController isKindOfClass:[MediaViewController class]]) {
        return [self viewControllerBeforeMediaViewController:(MediaViewController *)viewController];
    }
    return nil;
}

-(UIViewController *)swipeViewController:(SwipeViewController *)swipeViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PageViewController class]]) {
        return [self viewControllerAfterPageViewController:(PageViewController *)viewController];
    }
    else if ([viewController isKindOfClass:[MediaViewController class]]) {
        return [self viewControllerAfterMediaViewController:(MediaViewController *)viewController];
    }
    return nil;    
}

#pragma mark - PageViewController
-(UIViewController *)viewControllerBeforePageViewController:(PageViewController *)pageViewController {
    NSUInteger index = [self indexOfPageViewController:pageViewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    index--;
    return [self pageViewControllerAtIndex:index storyboard:pageViewController.storyboard];
}

-(UIViewController *)viewControllerAfterPageViewController:(PageViewController *)pageViewController {
    NSUInteger index = [self indexOfPageViewController:pageViewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index >= [self.pages count]) {
        return nil;
    }
    return [self pageViewControllerAtIndex:index storyboard:pageViewController.storyboard];
}

-(PageViewController *)pageViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (([self.pages count] == 0) || (index >= [self.pages count])) {
        return nil;
    }
    
    Page *page = [self.pages objectAtIndex:index];
    PageViewController *pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    [pageViewController setPage:page];
    return pageViewController;
}

-(NSUInteger)indexOfPageViewController:(PageViewController *)pageViewController {
    return [self.pages indexOfObject:pageViewController.page];
}

#pragma mark - MediaViewController
-(UIViewController *)viewControllerBeforeMediaViewController:(MediaViewController *)mediaViewController {
    NSUInteger index = [self indexOfMediaViewController:mediaViewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    index--;
    return [self mediaViewControllerAtIndex:index storyboard:mediaViewController.storyboard];
}

-(UIViewController *)viewControllerAfterMediaViewController:(MediaViewController *)mediaViewController {
    NSUInteger index = [self indexOfMediaViewController:mediaViewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index >= [self.media count]) {
        return nil;
    }
    return [self mediaViewControllerAtIndex:index storyboard:mediaViewController.storyboard];
}

-(MediaViewController *)mediaViewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    if (([self.media count] == 0) || (index >= [self.media count])) {
        return nil;
    }
    
    Media *media = [self.media objectAtIndex:index];
    MediaViewController *mediaViewController = [storyboard instantiateViewControllerWithIdentifier:@"mediaViewController"];
    [mediaViewController setMedia:media];
    return mediaViewController;
}

-(NSUInteger)indexOfMediaViewController:(MediaViewController *)mediaViewController {
    return [self.media indexOfObject:mediaViewController.media];
}

#pragma mark - ProgressManagerDataSource
-(NSSet *)progressItemIds {
    NSMutableSet *ids = [NSMutableSet set];
    for (Media *media in self.media) {
        [ids addObject:[media.mediaId copy]];
    }
    for (Page *page in self.pages) {
        [ids addObject:[page.pageId copy]];
    }
    return ids;
}

-(NSString *)courseId {
    return [self.course courseId];
}

@end
