//
//  SGSStopWatch.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/6/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "SGSStopWatch.h"

@implementation SGSStopWatch

- (id) init {
    if (self = [super init]) {
        runs = [[NSMutableArray alloc] init];
        timers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) startTimerWithName:(NSString *)_name {
    
    if ([timers objectForKey:_name] != nil) {
        [NSException raise:@"Duplicate Timer" format:@"a timer named [%@] already exists", _name];
    }
    
    SGSTimer * timer = [[SGSTimer alloc] init];
    timer.name = _name;
    [timers setObject:timer forKey:timer.name];
    [timer start];
}

- (void) stopTimerWithName:(NSString *)_name{
    SGSTimer * timer = [timers objectForKey:_name];
    if (timer == nil) {
        [NSException raise:@"Nonexistant Timer" format:@"there is no timer named [%@] to stop", _name];
    }
    
    [runs addObject:[timer stop]];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"SGSStopWatch results: [%@]",runs]; 
}

@end
