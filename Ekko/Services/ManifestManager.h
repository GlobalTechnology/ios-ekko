//
//  ManifestManager.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/29/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Manifest+Ekko.h"

@interface ManifestManager : NSObject

+(ManifestManager *)sharedManager;

-(void)syncManifest:(NSString *)courseId;
-(void)syncManifest:(NSString *)courseId complete:(void (^)())complete;

-(BOOL)hasManifestWithCourseId:(NSString *)courseId;
-(Manifest *)getManifestByCourseId:(NSString *)courseId withManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
