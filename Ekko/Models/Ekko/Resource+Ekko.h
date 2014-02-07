//
//  Resource+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/27/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Resource.h"
#import "Banner+Ekko.h"

@interface Resource (Ekko)

-(id)initWithBanner:(Banner *)banner;

-(BOOL)isFile;
-(BOOL)isUri;
-(BOOL)isEkkoCloudVideo;
-(BOOL)isArclight;

/**
 Returns the filename used to store or retrieve the resource from disk
 */
-(NSString *)filenameOnDisk;

-(NSString *)youtTubeVideoId;

@end
