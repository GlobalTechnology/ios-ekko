//
//  CourseCompleteViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/8/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseCompleteViewController.h"
#import "Manifest+Ekko.h"
#import "UIViewController+SwipeViewController.h"

@interface CourseCompleteViewController ()

@end

@implementation CourseCompleteViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationBar setDelegate:self];
    
    self.completeWebView.scrollView.bounces = NO;
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_ekko_quiz.png"];
    CGRect backgroundRect = self.completeWebView.bounds;
    UIGraphicsBeginImageContextWithOptions(backgroundRect.size, YES, [UIScreen mainScreen].scale);
    [backgroundImage drawInRect:CGRectMake(0.f, 0.f, backgroundRect.size.width, backgroundRect.size.height)];
    UIImage *backgroundResult = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.completeWebView.backgroundColor = [UIColor colorWithPatternImage:backgroundResult];
    
    NSString *completeHTML = @"<html><body style=\"color:#CF6D2C;font-family:helvetica;font-size:28px;text-align:center;\">%@</body></html>";
    NSString *completeMessage = self.course.completeMessage ?: [NSString stringWithFormat:@"Congratulations! You finished %@.", self.course.courseTitle];
    [self.completeWebView loadHTMLString:[NSString stringWithFormat:completeHTML, completeMessage] baseURL:nil];
    
    [[ProgressManager progressManager] addProgressDelegate:self forDataSource:self.course];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ProgressManager progressManager] removeProgressDelegate:self];
}

- (IBAction)courseListClicked:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

#pragma mark - CourseNavigationBarDelegate
-(void)navigateToPrevious {
    SwipeViewController *swipeViewController = self.swipeViewController;
    if (swipeViewController) {
        [swipeViewController swipeToPreviousViewController];
    }
}

-(void)navigateToNext {
    SwipeViewController *swipeViewController = self.swipeViewController;
    if (swipeViewController) {
        [swipeViewController swipeToNextViewController];
    }
}

#pragma mark - ProgressManagerDelegate
-(void)progressUpdateFor:(id<ProgressManagerDataSource>)dataSource currentProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationBar setProgress:progress];
    });
}

@end
