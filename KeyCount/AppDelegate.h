//
//  AppDelegate.h
//  KeyCount
//
//  Created by Shevchenko Nik on 01/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.


#import <Cocoa/Cocoa.h>
#import "Counter.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void) closePopup;

@end

