//
//  SettingsController.m
//  KeyCount
//
//  Created by Shevchenko Nik on 06/05/2015.
//  Copyright (c) 2015 Shevchenko Nik. All rights reserved.
//

#import "SettingsController.h"
#import "MainWindowController.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)quitButton:(id)sender
{
    [NSApp terminate:self];
}

- (IBAction)resetCounter:(id)sender
{
    [(MainWindowController*)self.parent resetCounter];
}

- (IBAction)emailButton:(id)sender
{
    [self sendEmailWithMail:@"" Address:@"nicola.shevchenko@gmail.com" Subject:@"Key Counter enquiry" Body:@"Hi Nik,"];
}

- (IBAction)openGitHub:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/nshevchenko/KeyCounter"]];
}


- (void) assignParent :(NSViewController*) parentC
{
    self.parent = parentC;
}


// helper

- (void)sendEmailWithMail:(NSString *) senderAddress Address:(NSString *) toAddress Subject:(NSString *) subject Body:(NSString *) bodyText {
    NSString *mailtoAddress = [[NSString stringWithFormat:@"mailto:%@?Subject=%@&body=%@",toAddress,subject,bodyText] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mailtoAddress]];
    NSLog(@"Mailto:%@",mailtoAddress);
}


@end
