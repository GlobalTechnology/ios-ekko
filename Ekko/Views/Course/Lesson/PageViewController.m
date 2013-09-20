//
//  PageViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "PageViewController.h"

#import "UIColor+Ekko.h"

@interface PageViewController ()

@end

@implementation PageViewController

@synthesize page = _page;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.webView.scrollView setBounces:NO];
    
    for (UIView *view in self.webView.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view setHidden:YES];
        }
    }
    
    [self.webView setOpaque:NO];
    [self.webView setBackgroundColor:[UIColor ekkoLightGrey]];
    [self.webView loadHTMLString:self.page.pageText baseURL:nil];
}

@end
