//
//  SGSTimer.h
//  iOS5-Facebook-Test
//
//  Created by Todd Marshall on 3/6/12.
//  Copyright (c) 2012 SunGard Global Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGSTimer : NSObject {
    BOOL isRunning;
    NSTimeInterval startTime;
    NSTimeInterval endTime;
}
@property (nonatomic, strong) NSString * name;

- (void) start;
- (NSString *) stop;

@end
