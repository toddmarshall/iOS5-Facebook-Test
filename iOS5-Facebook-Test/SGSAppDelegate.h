//
//  SGSAppDelegate.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SGSViewController.h"
#import "ExternalServiceController.h"

@interface SGSAppDelegate : UIResponder <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString * persistentStorePath;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ExternalServiceController * serviceController;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSString *persistentStorePath;

- (NSString *)applicationDocumentsDirectory;
@end
