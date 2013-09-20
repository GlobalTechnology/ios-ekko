//
//  QuizProtocol.h
//  Ekko
//
//  Created by Brian Zoetewey on 9/13/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

@protocol QuizProtocol <NSObject>
@required
@property (nonatomic, strong) Question *question;
+(UIViewController<QuizProtocol> *)viewControllerWithStoryboard:(UIStoryboard *)storyboard;
@end
