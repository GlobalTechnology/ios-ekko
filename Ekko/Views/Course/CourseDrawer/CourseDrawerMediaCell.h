//
//  CourseDrawerMediaCell.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/14/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Media+Ekko.h"

@interface CourseDrawerMediaCell : UICollectionViewCell

@property (nonatomic, weak) Media *media;
@property (nonatomic, weak) IBOutlet UIImageView *mediaImageView;

@end
