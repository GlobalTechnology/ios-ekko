//
//  MediaViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MediaViewController.h"
#import "Resource+Ekko.h"
#import "HubClient.h"
#import "ArclightClient.h"
#import "ResourceManager.h"
#import "ProgressManager.h"
#import "Lesson+Ekko.h"

@implementation MediaViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Resource *resource = self.media.resource;
    if (resource.provider == EkkoResourceProviderYouTube) {
        [self.tapGestureRecognizer setEnabled:NO];
        [self.mediaImage removeFromSuperview];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [webView.scrollView setBounces:NO];
        [self.view addSubview:webView];
        
        NSString *htmlString = @"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = %1$d\"/></head>"\
            @"<body style=\"background:#000;margin-top:0px;margin-left:0px\"><div><object width=\"%1$d\" height=\"%2$d\">"\
            @"<param name=\"movie\" value=\"http://www.youtube.com/v/%3$@&version=3&rel=0\"></param>"\
            @"<param name=\"wmode\" value=\"transparent\"></param>"\
            @"<embed src=\"http://www.youtube.com/v/%3$@&version=3&rel=0\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%1$d\" height=\"%2$d\"></embed>"\
            @"</object></div></body></html>";
        NSString *finalHtml = [NSString stringWithFormat:htmlString, (int)320, (int)180, [resource youtTubeVideoId]];
        [webView loadHTMLString:finalHtml baseURL:nil];
    }
    else {
        [self.tapGestureRecognizer setEnabled:YES];
        if ([self.media.mediaType isEqualToString:@"image"]) {
            [[ResourceManager sharedManager] getImageResource:[self.media resource] completeBlock:^(Resource *resource, UIImage *image) {
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mediaImage setImage:image];
                    });
                }
            }];
        }
        else {
            Resource *thumbnail = [self.media thumbnail];
            if (thumbnail) {
                [[ResourceManager sharedManager] getImageResource:thumbnail completeBlock:^(Resource *resource, UIImage *image) {
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mediaImage setImage:image];
                        });
                    }
                }];
            }
        }
    }
    [ProgressManager setItemComplete:self.media.mediaId forCourse:[self.media.lesson courseId]];
}

-(void)resourceService:(Resource *)resource image:(UIImage *)image {
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaImage setImage:image];
        });
    }
}

- (IBAction)handleTapGesture:(id)sender {
    if (self.isDownloading) {
        return;
    }
    if ([self.media.mediaType isEqualToString:@"video"] || [self.media.mediaType isEqualToString:@"audio"]) {
        Resource *resource = [self.media resource];
        if ([resource isUri]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resource.uri]];
        }
        else if ([resource isFile]) {
            [[ResourceManager sharedManager] getResource:resource progressBlock:^(Resource *resource, float progress) {
                self.downloading = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.progressView.isHidden) {
                        [self.progressView setHidden:NO];
                    }
                    [self.progressBar setProgress:progress];
                    [self.progressText setText:[NSString stringWithFormat:@"%i%%", (int)(progress*100)]];
                });
            } completeBlock:^(Resource *resource, NSString *path) {
                self.downloading = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.progressView.isHidden) {
                        [self.progressView setHidden:YES];
                    }
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer prepareToPlay];
                    [movieController.moviePlayer play];
                });
            }];
        }
        else if ([resource isEkkoCloudVideo]) {
            [[HubClient sharedClient] getECVResourceURL:[resource courseId] videoId:[resource videoId] urlType:EkkoCloudVideoURLTypeStream complete:^(NSURL *videoURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer prepareToPlay];
                    [movieController.moviePlayer play];
                });
            }];
        }
        else if ([resource isArclight]) {
            [[ArclightClient sharedClient] getVideoStreamUrl:resource.refId complete:^(NSURL *videoStreamUrl) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoStreamUrl];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer prepareToPlay];
                    [movieController.moviePlayer play];
                });
            }];
        }
    }
}

@end
