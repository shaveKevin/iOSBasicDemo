//
//  SKGCDTestObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKGCDTestObj.h"

@implementation SKGCDTestObj

- (instancetype)init {
    
    if (self = [super init]) {
        [self createSerialQueue];
    }
    return self;
}


// 创建串行队列
- (void)createSerialQueue  {
    
}

@end
// 知识普及：GCD全称是GrandCentral Dispatch
/*
 用户只需要将希望执行的任务放到适当的队列（Dispatch Queue）中，GCD就能自动的完成创建线程及执行任务等操作。另外还有NSThread和NSOperation这两者方案，NSThread需要自己管理线程的生命周期等等，NSOperation是对GCD的面向对象的封装，本质还是GCD。
 */
// 面试题解答： 1.GCD的队列（dispatch_queue_t）分哪两种类型？
/*
 答：有两种类型：
 1.串行队列Serial Dispatch Queue
 2.并行队列Concurrent Dispatch Queue
  1.1 什么是串行队列：使用一个线程，按照顺序等待上一个任务执行完之后再执行。
 
 */

// 参考链接：iOS-GCD的串行队列和并行队列的任务及实现 https://blog.csdn.net/c386890506/article/details/51171898
// iOS开发之多线程GCD详解  https://zhuanlan.zhihu.com/p/59219627
