//
//  DrawerViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/21/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MMDrawerController.h"
#import <TheKeyOAuth2Client.h>

@interface DrawerViewController : MMDrawerController<TheKeyOAuth2ClientLoginDelegate>

-(void)presentLoginDialog;

@end
