//
//  SKRunLoopObject.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/10/11.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//  面试题：1.runloop和线程有什么关系？
//  面试题：2.runloop的mode作用是什么？
//  面试题：3.以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？
//  面试题：4.猜想runloop内部是如何实现的？

@interface SKRunLoopObject : NSObject

- (void)runtimeTest;

@end

NS_ASSUME_NONNULL_END
