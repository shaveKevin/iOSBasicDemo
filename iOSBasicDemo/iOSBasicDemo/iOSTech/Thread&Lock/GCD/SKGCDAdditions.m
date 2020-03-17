//
//  SKGCDAdditions.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/23.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKGCDAdditions.h"
#import <pthread/pthread.h>

// 实现以下场景：
// 1.同一时间，只能有一个线程进行写的操作。
// 2.同一时间，允许有多个线程进行读的操作。
// 3.同一时间，不允许既有写的操作，又有读的操作。
@interface SKGCDAdditions  ()

@property (nonatomic, assign) pthread_rwlock_t lock;

@property (nonatomic, strong) dispatch_queue_t queue;


@end
@implementation SKGCDAdditions

- (instancetype)init {
    
    if (self = [super init]) {
        pthread_rwlock_init(&_lock,NULL);
        self.queue = dispatch_queue_create("con.shavekevin.queue", DISPATCH_QUEUE_CONCURRENT);
        
     }
    return self;
}

// 实现效果 多读单写(读写安全)
- (void)rw_file_method {
    
    [[[NSThread alloc]initWithTarget:self selector:@selector(readMethod) object:nil] start];
    [[[NSThread alloc]initWithTarget:self selector:@selector(writeMethod) object:nil] start];

}

- (void)readMethod {
    // 加锁
    pthread_rwlock_rdlock(&_lock);
    NSLog(@"读取方法");
    pthread_rwlock_unlock(&_lock);

    
}


- (void)writeMethod {
    pthread_rwlock_wrlock(&_lock);
    // 写入任务
    NSLog(@"写入方法");
    pthread_rwlock_unlock(&_lock);
    
}

- (void)readMethod01 {
    // 读
    dispatch_async(self.queue, ^{
        NSLog(@"读取方法");
    });
}

- (void)writeMethod01 {
    // 写
    dispatch_barrier_async(self.queue, ^{
        NSLog(@"写入方法");
    });
}

@end
// 面试题解答：iOS中读取文件安全的方案有哪些？
/*
 首先,读取和写入有以下方面
 IO操作，文件操作
 1.从文件中读取内容
 2.往文件中写入内容
 实现多读单写的方案有：
 1.pthread_rwlock  等待锁的过程会进入休眠
 2.dispatch_barrier 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的。如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果。
 */


