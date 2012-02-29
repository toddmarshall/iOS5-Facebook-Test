//
//  SGSFaceBookController.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>
#import "FBConnect.h"

#define K_FB_ACCESS_TOKEN @"FBAccessTokenKey"
#define K_FB_EXPIRATION_DATE @"FBExpirationDateKey"

typedef void (^SGSFBFailureBlock)(NSError * error);
typedef void (^SGSFBLoginSuccessBlock)(NSString * token);
typedef void (^SGSFBLogoutSuccessBlock)(void);
typedef void (^SGSFBFriendRequestSuccessBlock)(NSArray * friends);
typedef void (^SGSFBFriendRequestProgressBlock)(NSString * progressText, BOOL finished);

@interface SGSFaceBookController : NSObject <FBSessionDelegate, FBRequestDelegate> {
    
    SGSFBFailureBlock loginFailureBlock;
    SGSFBFailureBlock logoutFailureBlock;
    SGSFBFailureBlock friendRequestFailureBlock;
    
    SGSFBLoginSuccessBlock loginSuccessBlock;
    SGSFBLogoutSuccessBlock logoutSuccessBlock;
    SGSFBFriendRequestSuccessBlock friendRequestSuccessBlock;
    
    SGSFBFriendRequestProgressBlock friendRequestProgressBlock;

}

@property (nonatomic, strong) Facebook *facebook;

- (id) initWithAppId:(NSString *) appId;
- (BOOL) hasValidSession;
- (void) loginWithSuccessBlock:(SGSFBLoginSuccessBlock) successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock;
- (void) logoutWithSuccessBlock:(SGSFBLogoutSuccessBlock)successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock;
- (void) requestFriendsWithSuccessBlock:(SGSFBFriendRequestSuccessBlock) successBlock 
                       withFailureBlock:(SGSFBFailureBlock) failureBlock 
                      withProgressBlock:(SGSFBFriendRequestProgressBlock) progressBlock;
@end
