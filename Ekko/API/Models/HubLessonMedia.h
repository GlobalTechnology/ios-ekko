//
//  HubLessonMedia.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/10/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubLessonMedia : HubXMLModel

@property (nonatomic, strong) NSString *mediaId;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *resourceId;
@property (nonatomic, strong) NSString *thumbnailId;

@end
