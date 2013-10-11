//
//  CourseNavigationBar.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseNavigationBarDelegate;

@interface CourseNavigationBar : UIView

@property (nonatomic, weak) IBOutlet id<CourseNavigationBarDelegate> delegate;

-(void)setProgress:(float)progress;
-(void)setTitle:(NSString *)title;

@end

@protocol CourseNavigationBarDelegate <NSObject>
-(void)navigateToNext;
-(void)navigateToPrevious;
@end