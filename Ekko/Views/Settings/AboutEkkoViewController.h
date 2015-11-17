//
//  AboutEkkoViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/17/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutEkkoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *aboutWebView;

+ (id)allocWithRouterParams:(NSDictionary *)params;

@end
