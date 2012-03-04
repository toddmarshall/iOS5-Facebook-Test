//
//  ExternalServiceController.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/1/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SGSFaceBookController.h"
#import "FacebookFriend.h"
#import "Constants.h"

typedef void (^ExternalServiceControllerSuccessBlock)(void);
typedef void (^ExternalServiceControllerFailureBlock)(NSError * error);
typedef void (^ExternalServiceControllerUpdateFacebookFriendsSuccess)(int total, int added, int removed);
typedef void (^ExternalServiceControllerUpdateFacebookFriendsProgress)(NSString * progressText, BOOL finished);

@interface ExternalServiceController : NSObject <NSFetchedResultsControllerDelegate> {
    ExternalServiceControllerUpdateFacebookFriendsSuccess friendUpdateSuccessBlock;
    NSMutableDictionary * requestCache;
    
    
    
    // blocks
    ExternalServiceControllerUpdateFacebookFriendsSuccess updateFacebookFriendsSuccessBlock;
    ExternalServiceControllerUpdateFacebookFriendsProgress updateFacebookFriendsProgressBlock;
    ExternalServiceControllerFailureBlock updateFacebookFriendsFailureBlock;
    
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) SGSFaceBookController * facebookController;
@property (nonatomic, strong) NSString * facebookAppID;


+ (ExternalServiceController *) sharedInstance;

- (void) clearCaches;
- (void) startFacebookSession:(ExternalServiceControllerSuccessBlock) successBlock withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock;

- (void) updateFacebookFiends:(id) sender;
- (void) updateFacebookFriendsWithSuccessBlock:(ExternalServiceControllerUpdateFacebookFriendsSuccess) successBlock 
                             withProgressBlock:(ExternalServiceControllerUpdateFacebookFriendsProgress) progressBlock 
                              withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock;
@end
