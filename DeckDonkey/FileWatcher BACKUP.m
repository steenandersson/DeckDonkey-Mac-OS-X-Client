//
//  FileWatcher.m
//  DeckDonkey
//
//  Created by Steen Andersson on 11/23/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import "FileWatcher.h"
#import "FileEvaluator.h"
#import <CoreServices/CoreServices.h>
#import <Cocoa/Cocoa.h>

/* Notes on the FSEvent implementation:
 
 The application creates a stream by calling FSEventStreamCreate or FSEventStreamCreateRelativeToDevice. The stream initially has a retain count of 1. If desired, you can increment this count by calling FSEventStreamRetain.
 
 The application schedules the stream on the run loop by calling FSEventStreamScheduleWithRunLoop.
 
 The application tells the file system events daemon to start sending events by calling FSEventStreamStart.
 
 The application services events as they arrive. The API posts events by calling the callback function specified in step 1.
 
 The application tells the daemon to stop sending events by calling FSEventStreamStop.
 If the application needs to restart the stream, go to step 3.
 
 The application unschedules the event from its run loop by calling FSEventStreamUnscheduleFromRunLoop.
 
 The application invalidates the stream by calling FSEventStreamInvalidate.
 
 The application releases its reference to the stream by calling FSEventStreamRelease.

*/



@implementation FileWatcher

- (FileWatcher*)StartWatching;
{
    NSLog(@"Creating file watcher...2");
    
    /* Define variables and create a CFArray object containing
     CFString objects containing paths to watch.
     */
    
    CFStringRef mypath = CFSTR("/Users/Steen/Documents/Temp");
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
    void *callbackInfo = NULL; // could put stream-specific data here.
    CFTimeInterval latency = 2.0; /* Latency in seconds */
    
    /* Create the stream, passing in a callback */
    stream = FSEventStreamCreate(NULL,
                                 &FileWatcherCallback,
                                 callbackInfo,
                                 pathsToWatch,
                                 kFSEventStreamEventIdSinceNow, /* Or a previous event ID */
                                 latency,
                                 kFSEventStreamCreateFlagFileEvents /* Also add kFSEventStreamCreateFlagIgnoreSelf if lots of recursive callbacks */
                                 );
    
    
    // Schedule the Events Stream with FS
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(),         kCFRunLoopDefaultMode);
    // Start the Stream!
    FSEventStreamStart(stream);
    
    
    NSLog(@"Successful.\n");
    
    return(self);
}


+ (void)EvaluateFile:(NSString*)filepath
{
    //NSlog(@"Got Callback to Obj-C from C! With Path:%s", filepath);
}


void FileWatcherCallback(
                ConstFSEventStreamRef streamRef,
                void *clientCallBackInfo,
                size_t numEvents,
                void *eventPaths,
                const FSEventStreamEventFlags eventFlags[],
                const FSEventStreamEventId eventIds[])
{
    int i;
    char **paths = eventPaths;
    
    NSLog(@"Callback called\n");
    for (i=0; i<numEvents; i++) {
        
        /* flags are unsigned long, IDs are uint64_t */
        NSLog(@"Change %llu in %s, flags %u\n", eventIds[i], paths[i], eventFlags[i]);
        
        // Evaluate if this file has really changed
        //FileEvaluatorInstance.EvaluateAndUpdateCache(paths[i]);
        EvaluateFile(@"testpath"); //[NSString stringWithFormat:@"%s",paths[i]
        
    }
}



- (void)FileWatcherShutdown
{
    FSEventStreamStop(stream);
    
    FSEventStreamUnscheduleFromRunLoop(stream,CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    FSEventStreamInvalidate(stream);
    
    FSEventStreamRelease(stream);
}


@end
