//
//  FileWatcher.m
//  DeckDonkey
//
//  Created by Steen Andersson on 11/23/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import "FileWatcher.h"
#import "FileUploader.h"
#import <CoreServices/CoreServices.h>
#import <Cocoa/Cocoa.h>
#include <sys/stat.h>


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
    NSLog(@"Method: StartWatching...\n");
    
    // initialize the download queue
    uploadQueue = [[NSMutableDictionary alloc] init];
    [uploadQueue setValue:@"ToDownload" forKey:@"donkeytest" ];
    
    /* Define variables and create a CFArray object containing
     CFString objects containing paths to watch.
     */
    
    CFStringRef mypath = CFSTR("/Users/Steen/Documents/Temp");
    CFArrayRef pathsToWatch = CFArrayCreate(NULL, (const void **)&mypath, 1, NULL);
    CFTimeInterval latency = 2.0; /* Latency in seconds */
    
    //void *callbackInfo = (__bridge void *)self; // could put stream-specific data here.
    FSEventStreamContext context;
    //context.info = &uploadQueue;
    context.info = (__bridge void *)(uploadQueue);
    //context.info = CFBridgingRetain(uploadQueue);
    context.version = 0;
    context.retain = NULL;
    context.release = NULL;
    context.copyDescription = NULL;
    
    /* Create the stream, passing in a callback */
    stream = FSEventStreamCreate(NULL,
                                 &FileWatcherCallback,
                                 &context.info,
                                 pathsToWatch,
                                 kFSEventStreamEventIdSinceNow, /* Or a previous event ID */
                                 latency,
                                 kFSEventStreamCreateFlagFileEvents /* Also add kFSEventStreamCreateFlagIgnoreSelf if lots of recursive callbacks */
                                 );
    
    
    // Schedule the Events Stream with FS
    FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    // Start the Stream!
    FSEventStreamStart(stream);
    
    
    NSLog(@"Successful.\n");
    
   
    return(self);
}

//testing callback to Obj-C
- (void)ICanSeeObj
{
    donkeytest++;
    NSLog(@"*** I can see!! Donkeytest object variable=%i", donkeytest);
}

- (void)FileWatcherShutdown
{
    FSEventStreamStop(stream);
    
    FSEventStreamUnscheduleFromRunLoop(stream,CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);

    FSEventStreamInvalidate(stream);
    
    FSEventStreamRelease(stream);
}



// C syle functions:
//----------------
// All these functions must exist outside of the object hierarchy otherwise the callback c function won't be able to use them. (It can't access the Objective-C objectives because the callback can't pass in a link to a parent object to allow it to access the 'object space'. So it must live in oldschool C space). 



void FileWatcherCallback(
                         ConstFSEventStreamRef streamRef,
                         //FSEventStreamContext *clientCallBackInfo,
                         void *info,
                         size_t numEvents,
                         void *eventPaths,
                         const FSEventStreamEventFlags eventFlags[],
                         const FSEventStreamEventId eventIds[])
{
    int i;
    char **paths = eventPaths;
    
    // Retrieve pointer to the download Queue!
    //
    //NSMutableDictionary *queue = (__bridge NSMutableDictionary *)info;
    NSMutableDictionary *queue = CFBridgingRelease(info);
    //NSMutableDictionary *queue = (NSMutableDictionary *)CFBridgingRelease(clientCallBackInfo->info);
    // Try adding to the queue
    [queue setValue:@"ToDownload" forKey:@"donkeytest" ];
    
    // Loop through pathes and determine if they are files we want
    NSLog(@"Callback called\n");
    for (i=0; i<numEvents; i++) {
        
        /* flags are unsigned long, IDs are uint64_t */
        NSLog(@"Change %llu in %s, flags %u\n", eventIds[i], paths[i], eventFlags[i]);
        
        // Evaluate if this file has really changed and if so, add it to upload queue.
        if (EvaluateFile(paths[i]))
        {
            // Add it to the download queue
            //AddtoUploadQueue(paths[i], queue);
            // this makes it crash:  [parent ICanSeeObj];
            
            FileUploader *fileUploader = [[FileUploader alloc] init ];  // yes - maybe this shouldn't be re-created each time, but for the sake of prototyping, what the heck !
            [fileUploader UploadFile:(paths[i])];
            
        }
        
    }
}



void AddtoUploadQueue(char* filepath, NSMutableDictionary* queue)
{
    // add file to queue dictionary object which is watched by the uploader class which is on the wake up thang
    
    
    [queue setValue:@"ToDownload" forKey:[NSString stringWithCString:filepath encoding:NSASCIIStringEncoding] ];
    [queue setValue:@"ToDownload" forKey:@"donkeytest" ];
   
    NSInteger count = [queue count];
    id __unsafe_unretained objects[count];
    id __unsafe_unretained keys[count];
    [queue getObjects:objects andKeys:keys];
    
    NSLog(@"Queue looks like %li entries...\n", count);
    for (int i = 0; i < count; i++) {
        id obj = objects[i];
        id key = keys[i];
        NSLog(@"%@ -> %@", obj, key);
    }
  
   
    
    // MAYBE CHAIN is
    // 1. pass in NSMutableDictionary instance to the filewatcher
    // 2. file watcher sets that as the callback parameter
    // 3. callbakc handler then uses that attached obj ref to find the NSMutableDIctionary object instance with the file download queue in it?
    
    return;
}



bool EvaluateFile(char* filepath)
{
    // If the file has changed and it is a deck, then upload it!
    
    NSLog(@"eval file fn called for %s.\n", filepath);
    
    struct fileProperties changedFileProperties;
    
    struct stat st = {0};
    int ret = lstat(filepath, &st);  // error handling to be added here
    
    changedFileProperties.filepath = filepath;
    changedFileProperties.fileSize = (long long) st.st_size;
    changedFileProperties.lastWritten = (unsigned long long) st.st_mtime;
    
    printf("%s: mtime sec=%lld size=%lld\n", changedFileProperties.filepath,
           (long long) changedFileProperties.lastWritten,
           (long long) changedFileProperties.fileSize);
    
    
    //... Validate that the file changed is one we care about (a deck!)...
    
    ////    NSLog(@"File extension is: %s", extension);
    
    char extension[6] = "     \0";
    strcpy(extension, &filepath[strlen(filepath) - 5]);
    NSLog(@"Extension is: %s",extension);
    int diff = strcmp(extension, ".pptx");
    if (diff == 0)
    {
        // the extension is .pptx and its a deck!
        return YES;
    }
    else return NO; //ignore this file
    
}
                          
                                        


@end
