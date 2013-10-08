//
//  HubManifest.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"
#import "HubMeta.h"
#import "HubLesson.h"
#import "HubResource.h"
#import "HubQuiz.h"

@interface HubManifest : HubXMLModel

@property (strong, nonatomic) NSString *courseId;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic, strong) HubMeta *courseMeta;

@property (nonatomic, strong, readonly) NSMutableArray *content;
@property (nonatomic, strong, readonly) NSMutableArray *resources;

@property (nonatomic, strong) NSString *completeMessage;

@end
