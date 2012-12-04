//
//  AppDelegate.m
//  DeckDonkey
//
//  Created by Steen Andersson on 11/23/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application & events
    
    // Create and Start the FileWatcher
    
    NSLog(@"Starting watcher...");
    
    fileWatcherInstance = [FileWatcher alloc];
    
    [fileWatcherInstance StartWatching];
    
    // File Uploader Object Creation
    
    //????
    
    //[fileWatcherInstance InitializeQueue];
    
    /*NSTimer*timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    */
    
}

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];  // removed the retain param on additional declaration rapper due to ARC

    NSBundle *bundle = [NSBundle mainBundle];
    
    statusImage = [ [NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"DeckDonkeyLogo" ofType:@"png"]];
    statusHighlightImage = [ [NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"DeckDonkeyLogo" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusHighlightImage];
    [statusItem setMenu:statusMenu];
    [statusItem setToolTip:@"You do not need this..."];
    [statusItem setHighlightMode:YES];
    
}

- (void)dealloc
{
}

- (IBAction)LaunchWebsite:(id)sender
{
    NSLog(@"Is doing something");
    
}
- (IBAction)AddCommentToDeck:(id)sender
{
    NSLog(@"Is doing something");
    
}
- (IBAction)OpenPreferences:(id)sender
{
    NSLog(@"Is doing something");

}
- (IBAction)Help:(id)sender
{
    NSLog(@"Is doing something");
    
}
- (IBAction)Exit:(id)sender
{
    NSLog(@"Exiting...");
    
    [fileWatcherInstance FileWatcherShutdown];
    
    NSLog(@"FileWatcherStopped");
    
    exit(1);
}


//DELETE IF WE CAN BE 100% EVENT DRIVEN
// - (void)timerFired:(NSTimer*)theTimer
//{
//    /* effectively a main loop ;) */
//
//    FSEventStreamRef stream;
//    /* Create the stream before calling this. */
//    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(),         kCFRunLoopDefaultMode);
//
//}


@end
