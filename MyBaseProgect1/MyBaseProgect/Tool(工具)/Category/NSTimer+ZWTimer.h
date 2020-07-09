//
//  NSTimer+ZWTimer.h
//  共享蜂
//
//  Created by 张威威 on 2017/12/17.
//  Copyright © 2017年 张威威. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TimerCallback)(NSTimer *timer);
@interface NSTimer (ZWTimer)

+ (NSTimer *)ZW_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                      callback:(TimerCallback)callback;

+ (NSTimer *)ZW_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         count:(NSInteger)count
                                      callback:(TimerCallback)callback;

/** 暂停NSTimer */
- (void)pauseTimer;

/** 开始NSTimer */
- (void)resumeTimer;

/** 延迟开始NSTimer */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
