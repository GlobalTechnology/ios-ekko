//
//  PageViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/26/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Page.h"

@interface PageViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) Page *page;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
