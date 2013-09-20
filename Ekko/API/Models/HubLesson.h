//
//  HubLesson.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubLesson : HubXMLModel

@property (nonatomic, strong) NSString *lessonId;
@property (nonatomic, strong) NSString *lessonTitle;
@property (nonatomic, strong, readonly) NSMutableArray *media;
@property (nonatomic, strong, readonly) NSMutableArray *pages;

@end
