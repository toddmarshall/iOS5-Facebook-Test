//
//  SGSAppDelegate.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSFaceBookController.h"
#import "SGSFBFriend.h"

@interface SGSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SGSFaceBookController * facebookController;

@end
