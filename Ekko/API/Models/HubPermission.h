//
//  HubPermission.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/18/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "HubXMLModel.h"

@interface HubPermission : HubXMLModel

@property (nonatomic, strong) NSString *guid;
@property (nonatomic) BOOL enrolled;
@property (nonatomic) BOOL admin;
@property (nonatomic) BOOL pending;
@property (nonatomic) BOOL contentVisible;

@end
