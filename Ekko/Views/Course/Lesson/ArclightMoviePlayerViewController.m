//
//  ArclightMoviePlayerViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 6/27/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "ArclightMoviePlayerViewController.h"
#import "EventTracker.h"

#import "URLParser.h"

@interface ArclightMoviePlayerViewController ()
@property (nonatomic, strong, readwrite) NSString *sessionId;
@end

@implementation ArclightMoviePlayerViewController

-(id)initWithContentURL:(NSURL *)contentURL {
    self = [super initWithContentURL:contentURL];
    if (self != nil) {
        URLParser *parser = [[URLParser alloc] initWithURLString:[contentURL absoluteString]];
        [self setSessionId:[parser valueForVariable:@"apiSessionId"]];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerPlaybackDidFinishNotification:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.moviePlayer];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerDidExitFullscreenNotification:)
                                                     name:MPMoviePlayerDidExitFullscreenNotification
                                                   object:self.moviePlayer];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification {
//    [EventTracker trackPlayEventWithRefID:self.refId apiSessionID:self.sessionId streaming:YES mediaViewTimeInSeconds:0.0f mediaEngagementOver75Percent:NO];
}

-(void)moviePlayerDidExitFullscreenNotification:(NSNotification *)notification {

}

@end
