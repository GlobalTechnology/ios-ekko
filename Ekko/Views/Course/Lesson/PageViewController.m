//
//  PageViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "PageViewController.h"
#import "Lesson+View.h"

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.page) {
        [[ProgressManager progressManager] recordProgress:self.page.pageId inCourse:[self.page.manifest courseId]];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
