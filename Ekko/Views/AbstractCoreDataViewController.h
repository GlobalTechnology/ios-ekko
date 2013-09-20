//
//  AbstractCoreDataViewController.h
//  Ekko
//
//  Created by Brian Zoetewey on 8/7/13.
//  Copyright (c) 2013 Ekko Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractCoreDataViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

-(void)performFetch;

@end
