//
//  ViewController.h
//  KeyCount
//
//  Created by Shevchenko Nik on 01/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"


@interface MainWindowController : NSViewController <NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSView *header;
@property (weak) IBOutlet NSTextField *lastLog;
@property (strong) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet NSTableView *tableContentView;

- (IBAction)settingsButton:(id)sender;

@property( nonatomic) BOOL* open;
@property( nonatomic) BOOL* openSettings;

@property (nonatomic) id monitor;
@property (nonatomic, strong) NSArray* sortedKeys;
@property (nonatomic, strong) NSMutableDictionary* alphabet;
@property (nonatomic, strong) NSViewController* settingsC;
@property (nonatomic, strong) NSString* lastLogStr;

- (void) pressedButton: (NSString *) charPressed;
- (void) initWithLoadDictionary;
- (void) onItemClick;
- (void) resetCounter;


@end
