//
//  Resource.h
//  Ekko
//
//  Created by Brian Zoetewey on 10/23/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Resource : NSManagedObject

@property (nonatomic) int16_t internalProvider;
@property (nonatomic) int16_t internalType;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * resourceId;
@property (nonatomic, retain) NSString * sha1;
@property (nonatomic) int64_t size;
@property (nonatomic, retain) NSString * uri;

@end
