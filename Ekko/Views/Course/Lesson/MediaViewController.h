//
//  MediaViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Media+Ekko.h"

@interface MediaViewController : UIViewController

@property (nonatomic, strong) Media *media;
@property (nonatomic, weak) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressText;

@property (nonatomic, getter = isDownloading) BOOL downloading;

@end
