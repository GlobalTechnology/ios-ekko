//
//  PageViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "PageViewController.h"
#import "Lesson+Ekko.h"
#import "ProgressManager.h"

#import "UIColor+Ekko.h"
#import "UIWebView+Ekko.h"

@interface PageViewController ()

@end

@implementation PageViewController

@synthesize page = _page;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.webView.scrollView setBounces:NO];
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor ekkoLightGrey]];
    [self.webView loadLessonPageString:self.page.pageText];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ProgressManager setItemComplete:self.page.pageId forCourse:[self.page.lesson courseId]];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
