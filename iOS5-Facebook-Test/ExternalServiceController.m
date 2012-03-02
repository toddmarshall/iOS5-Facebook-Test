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

@end

@implementation ExternalServiceController
@synthesize facebookController;


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
        self.facebookController = [[SGSFaceBookController alloc] initWithAppId:@"161472237304575"];
    }
    return self;
}

- (void) startFacebookSession:(ExternalServiceControllerSuccessBlock) successBlock withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock {
    
    NSLog(@"starting session");
        
    [facebookController 
     loginWithSuccessBlock:(SGSFBLoginSuccessBlock)^(NSString *token) {
         NSLog(@"facebook login succeded.  token = [%@]", token);
         successBlock();
     } 
     withFailureBlock:(SGSFBFailureBlock)^(NSError *_error) {
         NSLog(@"facebook login failed with error = [%@]", _error);
         failureBlock(_error);
     }];
    

    
}

- (void) updateFacebookFiends:(id) sender {
    
}
- (void) updateFacebookFriendsWithSuccessBlock:(ExternalServiceControllerUpdateFacebookFriendsSuccess) successBlock 
                             withProgressBlock:(ExternalServiceControllerUpdateFacebookFriendsProgress) progressBlock 
                              withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock 
{
    ExternalServiceControllerSuccessBlock callWhenAuthenticated = ^(void) {
        
        if (![self.facebookController hasValidSession]) {
            NSLog(@"no session");
        }
        
        [self.facebookController requestFriendsWithSuccessBlock:^(NSArray *friends) 
         {
             NSLog(@"sucessfully retrieved friend list");
             [self didGetFriends:friends];
             
             
         } withFailureBlock:^(NSError *error) 
         {
             NSLog(@"friend list request failed with error = [%@]", error);
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

- (void) didGetFriends:(NSArray *) friends
{
    [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
     {
         SGSFBFriend * friend = (SGSFBFriend *) obj;
         NSLog(@"%@", friend);
     }];
}

@end
