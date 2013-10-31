//
//  UIWebView+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 10/31/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "UIWebView+Ekko.h"

static NSString *const EkkoWebViewLessonPageHTML =
    @"<html><head><style type=\"text/css\">"
    "html, body { font-family:\"Helvetica Neue\"; color:#212121; margin:12px}"
    "</style></head><body>%@</body></html>";

static NSString *const EkkoWebViewQuizQuestionHTML =
    @"<html><head><style type=\"text/css\">"
    "html, body { font-family:\"Helvetica Neue\"; font-size:26px; font-style:italic; color:#CF6D2C; margin:0; padding:0; width: 100%%;height: 100%%;}"
    "html { display:table;}"
    "body {display:table-cell; vertical-align:middle; text-align:center; padding:24px; -webkit-text-size-adjust:none;}"
    "</style></head><body><p>%@</p></body></html>";

static NSString *const EkkoWebViewQuizResultsHTML =
    @"<html><head><style type=\"text/css\">"
    "html, body { font-family:\"Helvetica Neue\"; font-size:26px; font-style:italic; color:#CF6D2C; margin:0; padding:0; width: 100%%;height: 100%%;}"
    "html { display:table;}"
    "body {display:table-cell; vertical-align:middle; text-align:center; padding:32px; -webkit-text-size-adjust:none;}"
    "div.label {text-align:left;}"
    "div.results {font-size:48px;}"
    "</style></head><body><div class=\"label\">%@:</div><div class=\"results\">%lu/%lu</div></body></html>";

static NSString *const EkkoWebViewCourseCompleteHTML =
    @"<html><head><style type=\"text/css\">"
    "html, body { font-family:\"Helvetica Neue\"; font-size:26px; font-style:italic; color:#CF6D2C; margin:0; padding:0; width: 100%%;height: 100%%;}"
    "html { display:table;}"
    "body {display:table-cell; vertical-align:middle; text-align:center; padding:24px; -webkit-text-size-adjust:none;}"
    "</style></head><body><p>%@</p></body></html>";

@implementation UIWebView (Ekko)

-(void)loadLessonPageString:(NSString *)string {
    [self loadHTMLString:[NSString stringWithFormat:EkkoWebViewLessonPageHTML, string] baseURL:nil];
}

-(void)loadQuizQuestionString:(NSString *)string {
    [self loadHTMLString:[NSString stringWithFormat:EkkoWebViewQuizQuestionHTML, string] baseURL:nil];
}

-(void)loadQuizResultsString:(NSString *)label total:(NSUInteger)total correct:(NSUInteger)correct {
    [self loadHTMLString:[NSString stringWithFormat:EkkoWebViewQuizResultsHTML, label, (unsigned long)correct, (unsigned long)total] baseURL:nil];
}

-(void)loadCourseCompleteString:(NSString *)string {
    [self loadHTMLString:[NSString stringWithFormat:EkkoWebViewCourseCompleteHTML, string] baseURL:nil];
}

@end
