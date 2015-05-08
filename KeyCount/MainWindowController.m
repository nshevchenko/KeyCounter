//
//  ViewController.m
//  KeyCount
//
//  Created by Shevchenko Nik on 01/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import "MainWindowController.h"
#import "SettingsController.h"


@implementation MainWindowController 

- (void)viewDidLoad
{
    // load basic info
    [super viewDidLoad];
    [_tableView setDataSource:self];
    [(SettingsController*)_settingsC assignParent:self];
    // change bg colorsaaaaaaa
    CGColorRef white = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0);
    [self setColor:&white : self.view];
    [self setColor:&white : _header];
    [self setColor:&white : self.settingsC.view];
    // tableView separator
    
    [_tableView setGridColor:[NSColor lightGrayColor]];
    [_tableView setGridStyleMask:NSGradientDrawsAfterEndingLocation];
}

- (void) setColor: (CGColorRef*) color : (NSView*) view
{
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor: *color];
    [view setWantsLayer:YES];
    [view setLayer:viewLayer];
}

- (void) initWithLoadDictionary
{
    _lastLogStr = @"";
    
    //loadDict
    if(_alphabet == nil)
        _alphabet = [[NSMutableDictionary alloc] init];
    
    for(char a = 'a'; a <= 'z'; a++)
    {
        [_alphabet setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%c", a]];
//        NSLog(@"%@", [NSString stringWithFormat:@"%c", a]);
    }
    [self sortedKeys];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (void)resetCounter
{
    NSLog(@"reset");
    [self initWithLoadDictionary];
    [_tableView reloadData];
}

- (void) pressedButton: (NSString *) charPressed
{
    NSLog(@"pressed key %@", charPressed);
    if( ! [[self findKey:charPressed] length])
        return;
    
    [self updateLog:charPressed];
    NSString* keyID = [self findKey:charPressed];
    NSLog(@"Found key %@", keyID);
    if(![keyID isEqualToString:@""])
        [_alphabet setObject: [NSNumber numberWithInt:[[_alphabet objectForKey: keyID] intValue] + 1]
                  forKey: keyID];
    NSLog(@"%li",(long) _open);
    // if popup is open sort and update view otherwise don't make extra computations. Stay Light.
    if(_open)
    {
        [self sortKeys];
        [_tableView reloadData];
    }
}

- (void) onItemClick
{
    if(_open)
        _open = 0;
    else
        _open = (BOOL*)1;
    [self sortKeys];
    [_tableView reloadData];
}

- (void) updateLog:(NSString*) charPressed
{
    if([_lastLogStr length] > 39)
    {
        _lastLogStr = [_lastLogStr substringFromIndex:1];
    }
    
    _lastLogStr = [_lastLogStr stringByAppendingString:charPressed];
    [_lastLog setStringValue:_lastLogStr];
}

- (NSString*) findKey: (NSString*) charPressed
{
    for(NSString* key in _alphabet )
        if([key isEqualToString:charPressed] || [[key uppercaseString] isEqualToString:charPressed])
            return key;
    return @"";
}

- (void) sortKeys
{
//    NSLog(@"sort keys");
    NSArray *keys = [_alphabet allKeys];
    
    _sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [_alphabet objectForKey:a];
        NSString *second = [_alphabet objectForKey:b];
        return [first compare:second];
    }];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
   // NSLog(@"%lu", (unsigned long)_alphabet.count);
    return _alphabet.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSInteger index = _alphabet.count - row - 1;
    NSString *identifier = [tableColumn identifier];
    if ([identifier isEqualToString:@"button"])
        return [_sortedKeys objectAtIndex:index];
    else
        return [_alphabet objectForKey:[_sortedKeys objectAtIndex:index]];
}

- (IBAction)settingsButton:(id)sender
{
    if(_tableView == nil)
        NSLog(@"interesting");
    
    NSLog(@"aiaia ");
    if(!self.openSettings)
    {
        [_scrollView addSubview:_settingsC.view];
        [_tableView setHidden:TRUE];
        self.openSettings = TRUE;
    }
    else
    {
        [_settingsC.view removeFromSuperviewWithoutNeedingDisplay];
        [_tableView setHidden:FALSE];
        self.openSettings = FALSE;
    }
}



@end