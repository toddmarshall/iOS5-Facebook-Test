//
//  SGSFBFriend.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 2/25/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "SGSFBFriend.h"

@implementation SGSFBFriend
@synthesize name, facebookId, fetchedDate;

- (id) initWithFBResultsDictionary:(NSDictionary *) resultsDictionary {
    if (self = [super init]) {
        assert(resultsDictionary != nil);
        self.facebookId = [resultsDictionary objectForKey:@"id"];
        self.name = [resultsDictionary objectForKey:@"name"];
        self.fetchedDate = [NSDate date];
    }
return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"id = [%@]\tname = [%@]", self.facebookId, self.name];
}
@end
