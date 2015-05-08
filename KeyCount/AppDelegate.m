//
//  AppDelegate.m
//  KeyCount
//
//  Created by Shevchenko Nik on 01/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowController.h"
#import "SettingsController.h"

@interface AppDelegate ()

- (IBAction)saveAction:(id)sender;
@property (nonatomic, strong) NSStatusItem* theItem;
@property (nonatomic, strong) NSPopover* popover;
@property (nonatomic, strong) NSStoryboard *storyboard;
@property (nonatomic, strong) MainWindowController * viewC;
@property (nonatomic, strong) id monitor;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    _viewC = (MainWindowController *)[_storyboard instantiateControllerWithIdentifier:@"viewC"];
    _viewC.settingsC = (SettingsController*)[_storyboard instantiateControllerWithIdentifier:@"settingsC"];
    _viewC.openSettings = FALSE;
    _viewC.open = FALSE;
    [self initStatusItem];
    [_viewC initWithLoadDictionary];
    [self loadData];
}

- (void) loadData
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Counter" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (Counter *counter in fetchedObjects) {
        
        [_viewC.alphabet setObject: counter.click
                      forKey: counter.button];
                 NSLog(@"read %@, %li", counter.button , [counter.click integerValue]);
    }
    [_viewC.tableView reloadData];
}


- (void) initStatusItem
{
    _popover = [NSPopover new];
    _popover.contentViewController = _viewC;
    _theItem = [[NSStatusBar systemStatusBar] statusItemWithLength:24];

    [_theItem setImage: [NSImage imageNamed:@"Status"]];
    [_theItem setHighlightMode:YES];
    [_theItem setTitle:@""];
    [_theItem setTarget:self];
    [_theItem setAction: @selector(pressPopup:)];

    _monitor = [NSEvent addGlobalMonitorForEventsMatchingMask: NSKeyDownMask handler:^(NSEvent* event){
        [_viewC pressedButton:event.characters ];

        //[self closePopup];
    }];
    // add local app monitoring of key pressing to show that it actually works :)
    [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent* event)
     {
         [_viewC pressedButton:event.characters];
         return event;
         
     }];
}


- (void) pressPopup: (id)sender
{
    if(!_viewC.open)
    {
        [self openPopup:sender];
    }
    else
        [self closePopup];
    [_viewC onItemClick];
}

- (void) openPopup: (id)sender
{
    [_popover showRelativeToRect:NSZeroRect ofView:(NSView *)sender preferredEdge:NSMinYEdge];
}

- (void) closePopup
{
    [_popover close];
}
       
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.heygames.KeyCount" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.heygames.KeyCount"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KeyCount" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            NSLog(@"doc %@", [applicationDocumentsDirectory path]);
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    NSError *error;
    //NSLog(@"app should ter");
    //NSLog(@"%@", _viewC.alphabet);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Counter" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for(NSString* key in _viewC.alphabet )
    {
    
        bool found = false;
        for (Counter *counter in fetchedObjects)
        {
            if([counter.button isEqualToString:key])
            {
                found = TRUE;
                counter.button = key;
                counter.click = [_viewC.alphabet objectForKey:key];
                
            }
        }
        if(!found)
        {
            Counter *counter = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Counter"
                                inManagedObjectContext:[self managedObjectContext]];
            counter.button = key;
            counter.click = [_viewC.alphabet objectForKey:key];
//            NSLog(@"save %@, %@", key , [_viewC.alphabet objectForKey:key]);
        }
//        NSLog(@"should save %@, %li", counter.button , (long)counter.click);
//        [_viewC.alphabet setObject: counter.click
//                            forKey: counter.button];
//        NSLog(@"read %@, %li", counter.button , [counter.click integerValue]);
    }
    
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
