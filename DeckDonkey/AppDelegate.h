//
//  AppDelegate.h
//  DeckDonkey
//
//  Created by Steen Andersson on 11/23/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#import "FileWatcher.h"




@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    //UI Element Declarations
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;
    
    //FileWatcher & Evaluators
    FileWatcher *fileWatcherInstance;

}

- (IBAction) LaunchWebsite:(id)sender;
- (IBAction) AddCommentToDeck:(id)sender;
- (IBAction) OpenPreferences:(id)sender;
- (IBAction) Help:(id)sender;
- (IBAction) Exit:(id)sender;

//- (void)timerFired:(NSTimer*)theTimer; //effectively the main loop

@property (assign) IBOutlet NSWindow *window;

@end
