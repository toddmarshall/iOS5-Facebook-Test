//
//  SGSTimer.m
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/6/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import "SGSTimer.h"

@implementation SGSTimer
@synthesize name;

- (void) start {
    if (isRunning) {
        NSLog(@"attempt to start timer that is already running");
        return;
    }
    
    startTime = [NSDate timeIntervalSinceReferenceDate];
    isRunning = true;
}

- (NSString *) stop {
    if (!isRunning) {
        NSLog(@"attempt to stop timer that isn't running");
        return nil;
    }
    
    
    endTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval elapsed = endTime - startTime;
    
    // calculate miliseconds
    NSUInteger elapsedMilliseconds = (NSUInteger) (elapsed * 1000) % 1000;
    
    // calculate seconds
    NSUInteger elapsedSeconds = (NSUInteger) elapsed;
    
    // add to runs
    if (elapsedSeconds > 0) {
        return [NSString stringWithFormat:@"%@ - (%f) %ds %dms", name, elapsed, elapsedSeconds, elapsedMilliseconds];
    }
    else
        return [NSString stringWithFormat:@"%@ - (%f) %dms", name, elapsed, elapsedMilliseconds];
    
    startTime = 0;
    endTime = 0;
    elapsedSeconds = 0;
    elapsedMilliseconds = 0;
    isRunning = false;
}


@end
