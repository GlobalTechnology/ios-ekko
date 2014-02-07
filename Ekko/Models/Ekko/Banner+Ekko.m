//
//  Banner+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/7/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "Banner+Ekko.h"
#import "Course+Ekko.h"

@implementation Banner (Ekko)

-(EkkoResourceType)type {
    return (EkkoResourceType)[self.internalType unsignedIntegerValue];
}

-(void)setType:(EkkoResourceType)type {
    self.internalType = [NSNumber numberWithUnsignedInteger:type];
}

+(NSSet *)keyPathsForValuesAffectingType {
    return [NSSet setWithObject:@"internalType"];
}

-(EkkoResourceProvider)provider {
    return (EkkoResourceProvider)[self.internalProvider unsignedIntegerValue];
}

-(void)setProvider:(EkkoResourceProvider)provider {
    self.internalProvider = [NSNumber numberWithUnsignedInteger:provider];
}

+(NSSet *)keyPathsForValuesAffectingProvider {
    return [NSSet setWithObject:@"internalProvider"];
}

-(NSString *)courseId {
    return self.course.courseId;
}

@end
