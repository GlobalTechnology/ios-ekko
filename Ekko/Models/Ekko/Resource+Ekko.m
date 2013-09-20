//
//  Resource+Ekko.m
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource+Ekko.h"
#import "Manifest+Ekko.h"
#import "HubClient.h"

@implementation Resource (Ekko)

-(EkkoResourceType)type {
    return (EkkoResourceType)[self resourceType];
}

-(void)setType:(EkkoResourceType)type {
    [self setResourceType:type];
}

-(EkkoResourceProvider)provider {
    return (EkkoResourceProvider)[self resourceProvider];
}

-(void)setProvider:(EkkoResourceProvider)provider {
    [self setResourceProvider:provider];
}

-(NSString *)courseId {
    return [self.course courseId];
}




-(NSURL *)imageUrl {
    if (self.sha1) {
        return [[HubClient sharedClient] URLWithSession:YES endpoint:[NSString stringWithFormat:@"courses/course/%@/resources/resource/%@", self.courseId, self.sha1]];
    }
    else if (self.uri) {
        return [NSURL URLWithString:self.uri];
    }
    return nil;
}

-(BOOL)isFile {
    return self.type == EkkoResourceTypeFile;
}

-(BOOL)isUri {
    return self.type == EkkoResourceTypeURI;
}

@end
