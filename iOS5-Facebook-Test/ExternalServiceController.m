//
//  ExternalServiceController.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/1/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "ExternalServiceController.h"

@interface ExternalServiceController(Private)
- (void) didGetFriends:(NSArray *) friends;
- (NSArray *) removeRemoveExistingFriends:(NSArray *) inputArray error:(NSError **)error;
@end

@implementation ExternalServiceController
@synthesize facebookController, facebookAppID, managedObjectContext, fetchedResultsController, stopWatch;


// Get the shared instance and create it if necessary.
+ (ExternalServiceController *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id) init {
    if (self = [super init]) {
        self.facebookAppID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"FacebookAppID"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        self.stopWatch = [[SGSStopWatch alloc] init];
    }
    return self;
}

- (void) clearCaches {
    
    updateFacebookFriendsFailureBlock = nil;
    updateFacebookFriendsProgressBlock = nil;
    updateFacebookFriendsSuccessBlock = nil;
    
}


- (void) startFacebookSession:(ExternalServiceControllerSuccessBlock) successBlock withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock {
    
    [stopWatch startTimerWithName:@"startFacebookSession"];
    if (!self.facebookController) {
        self.facebookController = [[SGSFaceBookController alloc] initWithAppId:self.facebookAppID];
    }
    
    NSLog(@"starting Facebook session");
        
    [facebookController 
     loginWithSuccessBlock:(SGSFBLoginSuccessBlock)^(NSString *token) {
         NSLog(@"facebook login succeded.  token = [%@]", token);
         [stopWatch stopTimerWithName:@"startFacebookSession"];
         successBlock();
     } 
     withFailureBlock:(SGSFBFailureBlock)^(NSError *_error) {
         NSLog(@"facebook login failed with error = [%@]", _error);
         [stopWatch stopTimerWithName:@"startFacebookSession"];
         failureBlock(_error);
     }];
    

    
}

- (void) updateFacebookFiends:(id) sender {
    
}
- (void) updateFacebookFriendsWithSuccessBlock:(ExternalServiceControllerUpdateFacebookFriendsSuccess) successBlock 
                             withProgressBlock:(ExternalServiceControllerUpdateFacebookFriendsProgress) progressBlock 
                              withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock 
{
    updateFacebookFriendsSuccessBlock = successBlock;
    updateFacebookFriendsProgressBlock = progressBlock;
    updateFacebookFriendsFailureBlock = failureBlock;
    
    ExternalServiceControllerSuccessBlock callWhenAuthenticated = ^(void) {
        
        [stopWatch startTimerWithName:@"requestFriends"];
        [self.facebookController requestFriendsWithSuccessBlock:^(NSArray *friends) 
         {
             NSLog(@"sucessfully retrieved friend list");
             [stopWatch stopTimerWithName:@"requestFriends"];
             [self didGetFriends:friends];
             
             
         } withFailureBlock:^(NSError *error) 
         {
             NSLog(@"friend list request failed with error = [%@]", error);
             [stopWatch stopTimerWithName:@"requestFriends"];
             failureBlock(error);
             
         } withProgressBlock:progressBlock];
    };
    
    ExternalServiceControllerFailureBlock failBlock = ^(NSError * error) {
        NSLog(@"facebook authentication failed with error = [%@]", error);
    };
    
    
    if (![self.facebookController hasValidSession]) {
        NSLog(@"no valid session");
        [self startFacebookSession:callWhenAuthenticated withFailureBlock:failBlock];
    }
    else {
        callWhenAuthenticated();
    }
    
}
- (NSArray *) removeRemoveExistingFriends:(NSArray *)inputArray error:(NSError **) error {
    
    [stopWatch startTimerWithName:@"filterFriends"];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"FacebookFriend" inManagedObjectContext:self.managedObjectContext];
    NSMutableArray * newFriends = [[NSMutableArray alloc] initWithCapacity:[inputArray count]];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    [inputArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(facebookId = %@)",  [obj objectForKey:@"id"]];
        [request setPredicate:pred];
        NSUInteger count = [managedObjectContext countForFetchRequest:request error:error];
        
        if (count == 0) {
            [newFriends addObject:obj];
        }
        else
            NSLog(@"filtered out [%@]", [obj objectForKey:@"name"]);
         
    }];
    
    [stopWatch stopTimerWithName:@"filterFriends"];
    
    return newFriends;
}
     

- (void) didGetFriends:(NSArray *) rawFriends
{
    NSError * error = nil;
    
    updateFacebookFriendsProgressBlock(@"finding new friends", false);
    
    NSArray * newFriends = [self removeRemoveExistingFriends:rawFriends error:&error];
    if (error) updateFacebookFriendsFailureBlock(error);
    
    
    [stopWatch startTimerWithName:@"savingNewFriends"];
    [newFriends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
     {
         NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"FacebookFriend" inManagedObjectContext:self.managedObjectContext];
         FacebookFriend * friend = [[FacebookFriend alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:self.managedObjectContext];
         friend.facebookId = [obj objectForKey:@"id"];
         friend.name = [obj objectForKey:@"name"];
         
         NSLog(@"added %@", friend);
     }];
    
    updateFacebookFriendsProgressBlock(@"saving friends", false);
    [self.managedObjectContext save:&error];
    [stopWatch stopTimerWithName:@"savingNewFriends"];
    if (error) updateFacebookFriendsFailureBlock(error);
    
    
    updateFacebookFriendsProgressBlock(@"finished updating friends", true);
    updateFacebookFriendsSuccessBlock([rawFriends count], [newFriends count], 0);
    
    NSLog(@"%@", stopWatch);
}

@end
