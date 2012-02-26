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
- (void) loginWithSuccessBlock:(SGSFBLoginSuccessBlock) successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock {
    
    loginSuccessBlock = successBlock;
    loginFailureBlock = failureBlock;
    
    
    // load up the saved authentication token if it's there
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDataKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        [facebook authorize:nil];
    }
    else {
        //TODO: what do I do if the session isn't valid?
    }
    
    
}

- (void) logoutWithSuccessBlock:(SGSFBLogoutSuccessBlock)successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock {
    logoutSuccessBlock = successBlock;
    logoutFailureBlock = failureBlock;
    
    [facebook logout];
    
}

- (void) requestFriendsWithSuccessBlock:(SGSFBFriendRequestSuccessBlock) successBlock withFailureBlock:(SGSFBFailureBlock) failureBlock {
    friendRequestSuccessBlock = successBlock;
    friendRequestFailureBlock = failureBlock;
    
    [facebook requestWithGraphPath:@"me/friends" andDelegate:self];
    
    
}

#pragma mark -- FBSessionDelegate
- (void) fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokeyKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
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
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    
    logoutSuccessBlock();
    
    
    
}

- (void) fbSessionInvalidated {
    NSLog(@"fbSessionInvalidated called");
    
}


- (void) fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokeyKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
}

#pragma mark -- FBRequestDelegate
- (void) request:(FBRequest *)request didLoad:(id)result {
    
    
    
    NSArray * data = nil;
    
    if ([result respondsToSelector:@selector(objectForKey:)]) {
        data = [result objectForKey:@"data"];
        NSMutableArray * friends = [[NSMutableArray alloc] initWithCapacity:[data count]];
        
        // prepping the friend list could get heavy when there are a lot.  do it on another thread
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SGSFBFriend * friend = [[SGSFBFriend alloc] initWithFBResultsDictionary:obj];
                [friends addObject:friend];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                friendRequestSuccessBlock(friends);
            }); 
        }); 
        
    }
}

- (void) request:(FBRequest *)request didFailWithError:(NSError *)error {
    
    friendRequestFailureBlock(error);
}


@end
