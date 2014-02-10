//
//  CoreDataXMLParser.m
//  Ekko
//
//  Created by Brian Zoetewey on 2/10/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "CoreDataXMLParser.h"

@implementation CoreDataXMLParser

-(id)initWithData:(NSData *)data managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithData:data];
    if (!self) {
        return nil;
    }
    self.managedObjectContext = managedObjectContext;
    return self;
}

@end
