//
//  Banner+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Banner.h"
#import "Resource.h"

@interface Banner (Ekko)

@property (nonatomic, readonly) NSString *courseId;
@property (nonatomic) EkkoResourceType type;
@property (nonatomic) EkkoResourceProvider provider;

@end
