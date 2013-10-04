//
//  MediaViewController.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "MediaViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Resource+Ekko.h"
#import "HubClient.h"
#import "ResourceManager.h"

@interface MediaViewController ()
@end

@implementation MediaViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    Resource *resource = self.media.resource;
    if (resource.provider == EkkoResourceProviderYouTube) {
        [self.mediaImage removeFromSuperview];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
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
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [self.view addGestureRecognizer:tapGestureRecognizer];
        
        if ([self.media.mediaType isEqualToString:@"image"]) {
            [[ResourceManager resourceManager] getImageResource:[self.media resource] completeBlock:^(UIImage *image) {
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
                [[ResourceManager resourceManager] getImageResource:thumbnail completeBlock:^(UIImage *image) {
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mediaImage setImage:image];
                        });
                    }
                }];
            }
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (UIGestureRecognizer *rec in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:rec];
    }
}

-(void)resourceService:(Resource *)resource image:(UIImage *)image {
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaImage setImage:image];
        });
    }
}

-(void)tapGesture:(id)sender {
    if ([self.media.mediaType isEqualToString:@"video"] || [self.media.mediaType isEqualToString:@"audio"]) {
        Resource *resource = [self.media resource];
        if ([resource isUri]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resource.uri]];
        }
        else if ([resource isFile]) {
            [[ResourceManager resourceManager] getResource:resource progressBlock:^(float progress) {} completeBlock:^(NSString *path) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:path]];
                    [self presentMoviePlayerViewControllerAnimated:movieController];
                    [movieController.moviePlayer prepareToPlay];
                    [movieController.moviePlayer play];
                });
            }];
        }
    }
}

@end
