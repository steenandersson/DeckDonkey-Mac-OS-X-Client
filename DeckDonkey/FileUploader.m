//
//  FileUploader.m
//  DeckDonkey
//
//  Created by Steen Andersson on 11/26/12.
//  Copyright (c) 2012 Steen Andersson. All rights reserved.
//

#import "FileUploader.h"
#import "DZWebDAVClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@implementation FileUploader


/**
 Enqueues an operation to upload the contents of a specified local
 file to a remote path using a `PUT` request.
 
 @param localSource A URL for a local file whose contents will be written the server.
 @param remoteDestination A remote path, relative to the HTTP client's base URL, to write the data to.
 @param success A block callback, to be fired upon successful completion, with no arguments.
 @param failure A block callback, to be fired upon the failure of either the request or the parsing of the request's data, with two arguments: the request operation and the network or parsing error that occurred.
 
 @see putURL:path:success:failure:
 */

- (void) UploadFile:(char *)filepath
{
    
    // Upload the file with webdav!
    
    // Load WebDAV credentials here
    // HARDCODED=BAD :)
//    NSSTring *serverurl = (NSURL *)@"http://www.breadandbutter.com.au/deckdonkey";
//    
//    NSURL *url = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
//    } failure:nil];
//    
//    [operation start];

    
//- (void)putURL:(NSURL *)localSource
//		  path:(NSString *)remoteDestination
//	   success:(void(^)(void))success
//	   failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


    
    
    
    
    //    to remove from the uploadQueue MutableDictionary
//NSMutableDictionary *stations = nil;
//stations = [[NSMutableDictionary alloc]
//            initWithContentsOfFile: pathToArchive];
//[stations removeObjectForKey:@"KIKT"];


}


@end
