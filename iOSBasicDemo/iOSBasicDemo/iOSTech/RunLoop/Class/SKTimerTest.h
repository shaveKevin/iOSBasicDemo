//
//  SKTimerTest.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

// 面试题：NSTimer有什么缺点?定时器除了用NSTimer意外还有其他的方式没？

NS_ASSUME_NONNULL_BEGIN

@interface SKTimerTest : NSObject
// 纳秒级别计算时间
- (void)matchAbsoluteTime;
// 屏幕刷新频率一样的定时器
- (void)testCADisplayLink;
// gcd实现timer
- (void)testGCDTimer;

@end

NS_ASSUME_NONNULL_END
