//
//  CourseNavigationBar.m
//  Ekko
//
//  Created by Brian Zoetewey on 9/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "CourseNavigationBar.h"
#import "UIColor+Ekko.h"
#import "UIImage+Ekko.h"

@interface CourseNavigationBar ()

@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *previousButton;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation CourseNavigationBar

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavigationBar];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initNavigationBar];
    }
    return self;
}

-(void)initNavigationBar {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    self.progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.progressBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.progressBar setProgressTintColor:[UIColor ekkoOrange]];
    [self.progressBar setTrackTintColor:[UIColor ekkoGrey]];
    [self.progressBar setProgress:0.f];
    [self addSubview:self.progressBar];
    
    self.previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.previousButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.previousButton setShowsTouchWhenHighlighted:YES];
    [self.previousButton setImage:[UIImage imageNamed:@"chevron-left.png" withTint:[UIColor grayColor]] forState:UIControlStateNormal];
    [self.previousButton addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.previousButton];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.nextButton setShowsTouchWhenHighlighted:YES];
    [self.nextButton setImage:[UIImage imageNamed:@"chevron-right.png" withTint:[UIColor grayColor]] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.nextButton];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.opaque = YES;
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.titleLabel];
    
    NSDictionary *views = @{@"progress": self.progressBar, @"previous": self.previousButton, @"next": self.nextButton, @"title": self.titleLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[previous(==45)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[next(==45)]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[previous]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[next]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-5-[progress]-5-[next]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[previous]-5-[title]-5-[next]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[progress(==4)]-5-[title]-5-|" options:0 metrics:nil views:views]];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0.0, 3.0);
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(CGSize)intrinsicContentSize {
    return CGSizeMake(-1.f, 45.f);
}

-(void)setProgress:(float)progress {
    [self.progressBar setProgress:progress];
}

-(void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

-(IBAction)previous:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigateToPrevious)]) {
        [self.delegate navigateToPrevious];
    }
}

-(IBAction)next:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigateToNext)]) {
        [self.delegate navigateToNext];
    }
}

@end
