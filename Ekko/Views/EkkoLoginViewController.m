//
//  EkkoLoginViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 11/15/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "EkkoLoginViewController.h"
#import "UIColor+Ekko.h"

@interface EkkoLoginViewController ()

@end

@implementation EkkoLoginViewController

+(NSString *)authNibName {
    return @"EkkoLoginViewController";
}

-(void)viewWillAppear:(BOOL)animated {
    self.webView.backgroundColor = [UIColor ekkoDarkBlue];
    [super viewWillAppear:animated];
}

@end
