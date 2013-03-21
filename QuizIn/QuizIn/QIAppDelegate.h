//
//  QIAppDelegate.h
//  QuizIn
//
//  Created by Rene Cacheaux on 3/21/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
