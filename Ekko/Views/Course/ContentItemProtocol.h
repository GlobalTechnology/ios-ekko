//
//  ContentItemProtocol.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/13/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentItem.h"

@protocol ContentItemProtocol <NSObject>
@required
@property (nonatomic, strong) ContentItem *contentItem;
+(UIViewController<ContentItemProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard;
@end
