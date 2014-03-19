//
//  CoreDataXMLParser.h
//  Ekko
//
//  Created by Brian Zoetewey on 2/10/14.
//  Copyright (c) 2014 Ekko Project. All rights reserved.
//

#import "EkkoXMLParser.h"

@interface CoreDataXMLParser : EkkoXMLParser

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(id)initWithData:(NSData *)data managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
