//
//  HubLessonPage.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubLessonPage : HubXMLModel

@property (nonatomic, strong) NSString *pageId;
@property (nonatomic, strong) NSString *pageText;

@end
