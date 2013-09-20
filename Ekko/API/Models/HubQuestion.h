//
//  HubQuestion.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubQuestion : HubXMLModel

@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *questionType;

@end
