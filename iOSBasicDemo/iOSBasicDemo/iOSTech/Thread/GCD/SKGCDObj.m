//
//  SKGCDObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/16.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKGCDObj.h"

@implementation SKGCDObj

- (instancetype)init {
    
    if (self = [super init]) {
        [self threadMethod03];
    }
    return self;
}
// 在viewdidload中调用
- (void)threadMethod01 {
    NSLog(@"执行任务1");
    // 同步 主队列  会产生死锁。
    // 队列的特点：排队，FIFO 先进先出。
    dispatch_sync(dispatch_get_main_queue(), ^{
        //
        NSLog(@"执行任务2");
    });
    NSLog(@"执行任务3");
    //dispatch_sync 立马在当前线程中执行任务，执行完毕之后才能继续往下进行。
    // 死锁原因分析：首先这个方法是一个主队列，  队列中有两个任务threadMethod01 和任务 NSLog(@"执行任务2");
    // 所有只有等任务threadMethod01执行完之后才能执行 任务2。任务2 的执行依赖于threadMethod01的执行。而dispatch_sync只有等任务2 结束后才能执行threadMethod01后续的任务。相互等待就造成了死锁，
    /*
      主线程       主队列
 
      任务1       主队列任务threadMethod01
      sync        任务2
      任务3
     */
    
}

- (void)threadMethod02 {
    // 不会产生死锁
    NSLog(@"执行任务1");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务2");
    });
    NSLog(@"执行任务3");
    //dispatch_async 不需要在当前线程中立即执行任务，所以可以继续执行。执行顺序 1 3 2

}

- (void)threadMethod03 {
    // 会产生死锁
    NSLog(@"执行任务1");
    dispatch_queue_t queue = dispatch_queue_create("com.shavekevin.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{// 0
        NSLog(@"执行任务2");
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");

        });
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
// 输出 1  5 2  之后死锁  分析：因为block0和block1都在同一个队列中，只有当block0执行完之后才能执行block1执行。
      /*
       子线程         串行队列
                     block0
                     block1
            
       */
}


- (void)threadMethod04 {
    // 不会产生死锁
    dispatch_queue_t queue1 = dispatch_queue_create("quque01", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("quque02", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"执行任务1");
    dispatch_sync(queue1, ^{// 0
        NSLog(@"执行任务2");
        dispatch_sync(queue2, ^{ // 1
            NSLog(@"执行任务3");
        });
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
    
     // 因为不同队列
    // 执行顺序是1 5 2 3 4
}


- (void)threadMethod05 {
    // 不会产生死锁
    dispatch_queue_t queue = dispatch_queue_create("quque", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"执行任务1");
    dispatch_sync(queue, ^{// 0
        NSLog(@"执行任务2");
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
        NSLog(@"执行任务4");
    });
    NSLog(@"执行任务5");
    // 虽然是相同队列 但是不是串行的，并发可以不用等当前队列执行完再执行。 并发不会阻塞线程。
}


- (void)threadMethod06 {
    // 打印结果是1  3
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        //  延迟的方法不会被执行。  带有afterDelay在runloop中，用到了NSTimer. 在runtime中等唤醒的时候才会调用定时器。 子线程中默认没有runloop 所以定时器不会工作。这个方法的本质是向runloop中添加定时器
        // performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay
        [self performSelector:@selector(additionMethod) withObject:nil afterDelay:.0];
        NSLog(@"3");
    });
}
- (void)additionMethod {
    NSLog(@"2");
}

@end
/*

                         iOS中常见的多线程的方案
 技术方案      简介                               语言           线程生命周期      使用频率

             一套通用的多线程api
             适用于unix/ linux/ window等系统        C             程序员管理      几乎不用
pthread      跨平台可移植
             使用难度大

             使用更加面向对象
NSThread     简单易用,可直接操作线程对象               OC            程序员管理      偶尔使用

 
             旨在替代NSThread等线程技术
GCD          充分利用设备的多核                       C             自动管理       经常使用
 

         
             基于GCD(底层是GCD)
 NSOperation 比GCD多了一些更简单实用的功能              OC            自动管理       经常使用
             使用更面向对象
 
 */
/*
 // 同步没有开辟线程 在当前线程中执行。异步，开辟线程。
    串行队列：任务一个接一个的执行，一个执行完毕再执行下一个。
    并发队列：允许多个任务并发执行。自动开启多个线程同时执行任务。并发功能只有在异步函数下才有效。
    同步异步 并发和串行
    同步异步只能决定是否能开辟新的线程(在哪一个线程执行)
    队列的并发和串行主要影响任务的执行方式。(是一个一个执行还是多个一起执行)
   
 
 各种队列的执行结果
 
                 并发队列         手动创建串行队列             主队列
 
 
               没有开启新线程       没有开启新线程         没有开启新线程
    同步 sync
               串行执行             串行执行               串行执行
 
 
                开启新线程        开启新线程             没有开启新线程
   异步 async
                 并发执行          串行执行               串行执行
 
 
 队列的类型： 1.并发队列 2.串行队列 3.主队列
 
 使用sync函数往当前串行队列中添加任务，就会死锁。
 
 */




