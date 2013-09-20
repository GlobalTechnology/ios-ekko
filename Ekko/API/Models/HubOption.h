//
//  HubOption.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/11/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubOption : HubXMLModel

@property (nonatomic, strong) NSString *optionId;
@property (nonatomic, strong) NSString *optionText;
@property (nonatomic) BOOL isAnswer;

@end
