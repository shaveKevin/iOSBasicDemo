//
//  SKGCDPrintObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/22.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKGCDPrintObj.h"

@implementation SKGCDPrintObj

- (instancetype)init {
    
    if (self = [super init]) {
        [self threadMethondThreeDemo];
    }
    return self;
}

- (void)threadMethondOneDemo {
    NSLog(@"任务1");
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
}
// 输出结果：任务1  任务2 任务3
/*
 分析：程序顺序执行 先执行任务1. 接着遇到一个同步的线程，这个时候程序会进入等待。 其中dispatch_get_global_queue 这是一个全局的队列。任务2被加到全局队列中。
    当并行队列任务2 执行完之后，回到主队列。继续执行任务3。所以这里打印结果是任务1  任务2 任务3
 */
- (void)threadMethondTwoDemo {
    // 创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("com.shavekeivn.queueA", DISPATCH_QUEUE_SERIAL);
    NSLog(@"任务1");
    dispatch_async(queue, ^{
        NSLog(@"任务2");
        dispatch_sync(queue, ^{
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
}

// 输出结果： 任务1  任务5或者任务2  1在前 5 和2 不确定
/*
 分析：输出结果为 1 5  2  或者 1 2 5  。  程序顺序执行 执行任务1. 然后遇到异步线程 串行队列。 这个时候将任务2 和同步线程 任务4 加入到异步线程中。
    异步线程，所以任务5不需要等待直接执行。因为5 直接执行。所以这里 2 和 5 的输出顺序不定。任务4 比任务3 先加入串行队列。任务3 要等任务4 执行完毕之后才执行。但是任务3所在的同步线程会阻塞。所以4 必须等3执行完之后在执行。这样就陷入了互相等待，就造成死锁。
    
 */
- (void)threadMethondThreeDemo {
    NSLog(@"任务1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务2");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");

}
// 输出结果 1  2 和5 顺序不定 3在4的后面
/*
 分析：首先会先将任务1 异步线程 任务5 加到主队列中。  异步线程中的是 任务2 同步线程 任务4
      先执行1 然后将异步线程中的任务加到global queue中 因为是异步线程，所以5不用等待 直接执行。所以 2 和5 的输出顺序不定。
 
 */
- (void)threadMethondFourDemo {
    
}


@end
