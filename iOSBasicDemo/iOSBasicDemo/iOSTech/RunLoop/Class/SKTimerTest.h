//
//  SKTimerTest.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

// 面试题：NSTimer有什么缺点?定时器除了用NSTimer意外还有其他的方式没？
// 面试题：如果让你实现一个定时器你怎么实现？
NS_ASSUME_NONNULL_BEGIN

@interface SKTimerTest : NSObject
// 纳秒级别计算时间
- (void)matchAbsoluteTime;
// 屏幕刷新频率一样的定时器
- (void)testCADisplayLink;
// gcd实现timer
- (void)testGCDTimer;
/*
 定时器的实现(dispatch_source_t)
 如果要实现对应的target和selector可以自己实现 原理和下面的实现基本一致。
 */
+ (NSString *)executeTask:(void (^)(void))action
                  startAt:(NSTimeInterval)start
             timeInterval:(NSTimeInterval)timeInterval
                  repeats:(BOOL)repeats
                    async:(BOOL)async;

+ (void)cancelTask:(NSString *)taskID;

@end

NS_ASSUME_NONNULL_END
