//
//  SGSStopWatch.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/6/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGSTimer.h"

@interface SGSStopWatch : NSObject {
    NSMutableArray * runs;
    NSMutableDictionary * timers;
    
}

- (void) startTimerWithName:(NSString *)name;
- (void) stopTimerWithName:(NSString *)name;
@end
