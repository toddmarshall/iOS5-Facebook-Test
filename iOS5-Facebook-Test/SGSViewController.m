//
//  SGSViewController.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "SGSViewController.h"


@interface SGSViewController ()

@end

@implementation SGSViewController
@synthesize progressLabel, spinner, facebookController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	SGSAppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    // we're logged in, get friends
    [appDelegate.facebookController requestFriendsWithSuccessBlock:^(NSArray *friends) 
     {
         NSLog(@"sucessfully retrieved friend list");
         [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
          {
              SGSFBFriend * friend = (SGSFBFriend *) obj;
              NSLog(@"%@", friend);
          }];
     } withFailureBlock:^(NSError *error) 
     {
         NSLog(@"friend list request failed with error = [%@]", error);
     } withProgressBlock:^(NSString *progressText, BOOL finished) 
    {
        self.progressLabel.text = progressText;
        if (finished) [self.spinner stopAnimating];
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
