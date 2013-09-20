//
//  HubCourse.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/4/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"
#import "HubMeta.h"

@interface HubCourse : HubXMLModel

@property (strong, nonatomic) NSString *courseId;
@property (nonatomic) int64_t courseVersion;
@property (nonatomic, strong) HubMeta *courseMeta;
@property (nonatomic, strong, readonly) NSMutableArray *resources;

-(HubResource *)bannerResource;

@end
