//
//  FileWatcher.h
//  DeckDonkey
//
//  Created by Steen Andersson on 11/23/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreServices/CoreServices.h>
#import <Cocoa/Cocoa.h>

typedef struct fileProperties {
    char *filepath;            // full path on disk
    unsigned long long fileSize;     // size on disk
    unsigned long long lastWritten;  // unix time in seconds since 1970.
}; // NOT CURRENTLY USED

//static NSMutableDictionary *uploadQueue = nil; //outside object heirachy so C-callbacks can see it
//void InitializeQueue(void);


@interface FileWatcher : NSObject
{
    FSEventStreamRef stream; //File System Stream Object
    int donkeytest;
    NSMutableDictionary *uploadQueue; 

}

- (FileWatcher*)StartWatching;

- (void)FileWatcherShutdown;

//test for callback context
- (void)ICanSeeObj;

void FileWatcherCallback(ConstFSEventStreamRef streamRef,
                         //FSEventStreamContext *clientCallBackInfo,
                         void *info,
                         size_t numEvents,
                         void *eventPaths,
                         const FSEventStreamEventFlags eventFlags[],
                         const FSEventStreamEventId eventIds[]);

bool EvaluateFile(char* filepath);

char* GetFileExtension(char *filepath);

void AddtoUploadQueue(char* filepath, NSMutableDictionary* queue);

@end
