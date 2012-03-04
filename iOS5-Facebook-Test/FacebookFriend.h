//
//  FacebookFriend.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/3/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FacebookFriend : NSManagedObject

@property (nonatomic, retain) NSString * facebookId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * image;

@end
