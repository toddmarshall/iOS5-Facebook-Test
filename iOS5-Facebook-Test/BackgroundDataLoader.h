//
//  BackgroundDataLoader.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/4/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BackgroundDataLoader;

@protocol BackgroundDataLoaderDelegate <NSObject>
// Notification posted by NSManagedObjectContext when saved.
- (void)loaderDidSave:(NSNotification *)saveNotification;

// Called by the importer when parsing is finished.
- (void)loaderDidFinishFetchingData:(BackgroundDataLoader *)loader;

// Called by the importer in the case of an error.
- (void)loaderDidSave:(BackgroundDataLoader *)loader didFailWithError:(NSError *)error;
@optional 


@end

@interface BackgroundDataLoader : NSObject

@end
