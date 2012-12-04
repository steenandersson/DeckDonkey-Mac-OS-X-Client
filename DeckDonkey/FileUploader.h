//
//  FileUploader.h
//  DeckDonkey
//
//  Created by Steen Andersson on 11/26/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileWatcher.h"

@interface FileUploader : NSObject

- (void) UploadFile:(char *)filepath;

@end
