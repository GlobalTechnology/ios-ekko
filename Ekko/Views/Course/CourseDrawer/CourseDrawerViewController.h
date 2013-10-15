//
//  CourseDrawerViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/14/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseViewController.h"
#import "ProgressManager.h"
#import "Manifest+Ekko.h"

@interface CourseDrawerViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ProgressManagerDelegate>

@property (nonatomic, weak) CourseViewController *courseViewController;
@property (nonatomic, weak) ContentItem *item;

@property (nonatomic, weak) IBOutlet UICollectionView *mediaCollectionView;
@property (nonatomic, weak) IBOutlet UIProgressView *courseProgressView;
@property (nonatomic, weak) IBOutlet UITableView *lessonTableView;

@end
