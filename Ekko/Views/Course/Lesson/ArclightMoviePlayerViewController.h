//
//  ArclightMoviePlayerViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 6/27/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface ArclightMoviePlayerViewController : MPMoviePlayerViewController

@property (nonatomic, readonly, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *refId;

@end
