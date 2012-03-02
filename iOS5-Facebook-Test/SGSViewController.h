//
//  SGSViewController.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSFaceBookController.h"
#import "SGSFBFriend.h"
#import "SGSAppDelegate.h"
#import "ExternalServiceController.h"

@interface SGSViewController : UIViewController

@property (strong, nonatomic) SGSFaceBookController * facebookController;
@property (strong, nonatomic) IBOutlet UILabel * progressLabel; 
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * spinner;

- (IBAction) updateFriendList:(id)sender;
@end
