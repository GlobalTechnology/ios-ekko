//
//  HubMeta.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/9/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"
#import "HubResource.h"

@interface HubMeta : HubXMLModel

@property (strong, nonatomic) NSString *courseTitle;
@property (strong, nonatomic) NSString *authorName;
@property (strong, nonatomic) NSString *authorEmail;
@property (strong, nonatomic) NSString *authorUrl;
@property (strong, nonatomic) NSString *courseDescription;
@property (strong, nonatomic) NSString *courseCopyright;
@property (nonatomic, strong) NSString *bannerId;

@end
