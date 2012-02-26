//
//  SGSFBFriend.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGSFBFriend : NSObject
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * facebookId;
@property (strong, nonatomic) NSDate * fetchedDate;

- (id) initWithFBResultsDictionary:(NSDictionary *) resultsDictionary;
@end
