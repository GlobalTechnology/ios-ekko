//
//  Media+Ekko.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/28/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import "Media.h"
#import "Resource+Ekko.h"

@interface Media (Ekko)

-(Resource *)resource;
-(Resource *)thumbnail;

@end
