//
//  SGSFaceBookController.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "SGSFaceBookController.h"
#import "SGSFBFriend.h"


@implementation SGSFaceBookController
@synthesize facebook;

- (id) initWithAppId:(NSString *) appId {
    if (self = [super init]) {
        facebook = [[Facebook alloc] initWithAppId:appId andDelegate:self];
        
    }
    return self;
}

#pragma mark -- actions
- (BOOL) hasValidSession {
    return [facebook isSessionValid];
}

- (void) loginWithSuccessBlock:(SGSFBLoginSuccessBlock) successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock {
    
    loginSuccessBlock = successBlock;
    loginFailureBlock = failureBlock;
    
    
    // load up the saved authentication token if it's there
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:K_FB_ACCESS_TOKEN] && [defaults objectForKey:K_FB_EXPIRATION_DATE]) {
        facebook.accessToken = [defaults objectForKey:K_FB_ACCESS_TOKEN];
        facebook.expirationDate = [defaults objectForKey:K_FB_EXPIRATION_DATE];
    }
    
    
    if (![facebook isSessionValid]) {
    
        [facebook authorize:nil];
    }
    else {
        successBlock(facebook.accessToken);
    }
    
    
}

- (void) logoutWithSuccessBlock:(SGSFBLogoutSuccessBlock)successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock {
    logoutSuccessBlock = successBlock;
    logoutFailureBlock = failureBlock;
    
    [facebook logout];
    
}

- (void) requestFriendsWithSuccessBlock:(SGSFBFriendRequestSuccessBlock) successBlock 
                       withFailureBlock:(SGSFBFailureBlock) failureBlock 
                      withProgressBlock:(SGSFBFriendRequestProgressBlock) progressBlock {
    friendRequestSuccessBlock = successBlock;
    friendRequestFailureBlock = failureBlock;
    friendRequestProgressBlock = progressBlock;
    
    progressBlock(@"requesting friend list", false);
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    
    
}

#pragma mark -- FBSessionDelegate
- (void) fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:K_FB_ACCESS_TOKEN];
    [defaults setObject:[facebook expirationDate] forKey:K_FB_EXPIRATION_DATE];
    [defaults synchronize];
    
    
    loginSuccessBlock([facebook accessToken]);
}

- (void) fbDidNotLogin:(BOOL)cancelled {
    
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    
    if (cancelled) {
        [errorDetail setValue:@"Facebook login cancelled" forKey:NSLocalizedDescriptionKey];  
    }
    
    loginFailureBlock([NSError errorWithDomain:@"com.sungard.consulting.facebook" code:100 userInfo:errorDetail]);
    
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:K_FB_ACCESS_TOKEN]) {
        [defaults removeObjectForKey:K_FB_ACCESS_TOKEN];
        [defaults removeObjectForKey:K_FB_EXPIRATION_DATE];
        [defaults synchronize];
    }
    
    
    logoutSuccessBlock();
    
    
    
}

- (void) fbSessionInvalidated {
    NSLog(@"fbSessionInvalidated called");
    
}


- (void) fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:K_FB_ACCESS_TOKEN];
    [defaults setObject:[facebook expirationDate] forKey:K_FB_EXPIRATION_DATE];
    [defaults synchronize];
    
}

#pragma mark -- FBRequestDelegate
- (void) request:(FBRequest *)request didLoad:(id)result {
    
    
    
    NSArray * data = nil;
    
    if ([result respondsToSelector:@selector(objectForKey:)]) {
        data = [result objectForKey:@"data"];
        NSMutableArray * friends = [[NSMutableArray alloc] initWithCapacity:[data count]];
        
        friendRequestProgressBlock(@"processing friends", false);
        // prepping the friend list could get heavy when there are a lot.  do it on another thread
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SGSFBFriend * friend = [[SGSFBFriend alloc] initWithFBResultsDictionary:obj];
                [friends addObject:friend];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                friendRequestSuccessBlock(friends);
                friendRequestProgressBlock(@"finished", true);
            }); 
        }); 
        
    }
}

- (void) request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    if (friendRequestProgressBlock != nil) {
        friendRequestProgressBlock(@"retrieving friends", false);
    }
    
}

- (void) request:(FBRequest *)request didFailWithError:(NSError *)error {
    
    friendRequestFailureBlock(error);
    if (friendRequestProgressBlock != nil) {
        friendRequestProgressBlock(@"failed", true);
    }
    
}


@end
