//
//  ExternalServiceController.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/1/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGSFaceBookController.h"
#import "SGSFBFriend.h"

typedef void (^ExternalServiceControllerSuccessBlock)(void);
typedef void (^ExternalServiceControllerFailureBlock)(NSError * error);
typedef void (^ExternalServiceControllerUpdateFacebookFriendsSuccess)(int total, int added, int removed);
typedef void (^ExternalServiceControllerUpdateFacebookFriendsProgress)(NSString * progressText, BOOL finished);

@interface ExternalServiceController : NSObject {
    ExternalServiceControllerUpdateFacebookFriendsSuccess friendUpdateSuccessBlock;
}
@property (nonatomic, strong) SGSFaceBookController * facebookController;

+ (ExternalServiceController *) sharedInstance;

- (void) startFacebookSession:(ExternalServiceControllerSuccessBlock) successBlock withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock;

- (void) updateFacebookFiends:(id) sender;
- (void) updateFacebookFriendsWithSuccessBlock:(ExternalServiceControllerUpdateFacebookFriendsSuccess) successBlock 
                             withProgressBlock:(ExternalServiceControllerUpdateFacebookFriendsProgress) progressBlock 
                              withFailureBlock:(ExternalServiceControllerFailureBlock) failureBlock;
@end
