//
//  QIMasterViewController.h
//  QuizIn
//
//  Created by Rene Cacheaux on 3/21/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QIDetailViewController;

#import <CoreData/CoreData.h>

@interface QIMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) QIDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
