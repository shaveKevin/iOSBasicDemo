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
        [self dispatch_semaphore];
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
// 输出结果 1  2 和5 顺序不定 3在4的前面
/*
 分析：首先会先将任务1 异步线程 任务5 加到主队列中。  异步线程中的是 任务2 同步线程 任务4
      先执行1 然后将异步线程中的任务加到global queue中 因为是异步线程，所以5不用等待 直接执行。所以 2 和5 的输出顺序不定。
      然后看异步线程中的执行顺序。任务2执行完成时候。遇到同步线程 将同步线程的任务加到主线程里，这个时候加入的任务3 在任务5 的后面。当任务3执行完以后。
      没有阻塞继续执行任务4  3 和 4 是顺序执行没有阻塞。  所以得出结论 1先执行 2 和5 顺序不定  3 在4的前面
 */
- (void)threadMethondFourDemo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"任务1");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"任务2");
        });
        NSLog(@"任务3");
    });
    NSLog(@"任务4");
    while (1) {

    }
    NSLog(@"任务5");

}
// 输出结果:
/*
 分析:输出1 和 4  但是不顺序不定  首先观察是异步线程  任务4不需要等待，所以这个时候1和4 输出顺序不一定。
    全局队列中加入的是  任务1 同步线程 任务3
 当任务4 完成之后 进入死循环  主线程阻塞。加到全局队列中的异步线程不受影响继续执行任务1 后的同步线程
  在同步线程中 任务2 加到了主线程。并且 任务3 必须等任务2 完成之后才能执行。但是这个时候 while(1)的时候 没有跳出逻辑，这里会因为循环造成阻塞。不会执行 任务2  这个时候任务3 也不会执行了。
       任务5 由于循环阻塞也不会执行。
 */
/*
 信号量的使用场景 粒度较小 相比较队列和barrier来说粒度算是小的
  可以当做锁来用当数量为0时加锁 不为0 的时候可以访问
 */
- (void)dispatch_semaphore {
    dispatch_semaphore_t semphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        // 当前信号量的值不为0 的时候执行 如果为0 那么就等待  然后信号量做-1操作
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
        NSLog(@"wait");
        // 信号量+1操作
        dispatch_semaphore_signal(semphore);
    });
    
}

@end
