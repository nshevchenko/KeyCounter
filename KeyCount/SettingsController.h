//
//  SettingsController.h
//  KeyCount
//
//  Created by Shevchenko Nik on 06/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsController : NSViewController

@property (nonatomic) BOOL openSettings;
@property (nonatomic, strong) NSViewController* parent;

- (void) assignParent: (NSViewController*) parent;
- (IBAction)quitButton:(id)sender;
- (IBAction)resetCounter:(id)sender;
- (IBAction)emailButton:(id)sender;
- (IBAction)openGitHub:(id)sender;

@end
