//
//  SKGCDSafeAnalysis.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKGCDSafeAnalysis.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>


@interface SKGCDSafeAnalysis()
//  High level - lock  高级锁  自旋锁
@property (nonatomic, assign) OSSpinLock  osspinklock;
//  low level lock  低级锁 等不到锁就休眠   互斥锁
@property (nonatomic, assign) pthread_mutex_t  pthreadLock;

// 条件
@property (nonatomic, assign) pthread_cond_t cond;

@property (nonatomic, strong) NSMutableArray *data;
// 对pthread_mutex_t的封装
@property (nonatomic, strong) NSLock *lock;
// 条件锁
@property (nonatomic, strong) NSCondition *condation;
//
@property (nonatomic, strong) NSThread *currentThread;
// 条件锁
@property (nonatomic, strong) NSConditionLock *condationLock;
// 信号量
@property (nonatomic, strong) dispatch_semaphore_t semaphore;


@end

@implementation SKGCDSafeAnalysis

- (instancetype)init {
    
    if (self = [super init]) {
        // 初始化锁
         _osspinklock = OS_SPINLOCK_INIT;
        [self pthread_attr_init];
        self.data = [NSMutableArray array];
        // 条件初始化
        pthread_cond_init(&_cond, NULL);
                
        self.lock = [[NSLock alloc]init];
        self.condation = [[NSCondition alloc]init];
        self.condationLock = [[NSConditionLock alloc]initWithCondition:1];
        self.semaphore = dispatch_semaphore_create(5);
    }
    return self;
}

- (void)osspinlock {
    // 只有使用的是同一把锁才可以进行多线程任务的处理
    // 加锁
    OSSpinLockLock(&_osspinklock);
    // do  something
    [self doSomething];
    // 解锁
    OSSpinLockUnlock(&_osspinklock);
    
}


- (void)os_unfair_lock {
    if (@available(iOS 10.0, *)) {
        
        // 初始化锁
        os_unfair_lock  lock = OS_UNFAIR_LOCK_INIT;
        //加锁
        os_unfair_lock_lock(&lock);
        // 执行任务
        [self doSomething];
        // 解锁
        os_unfair_lock_unlock(&lock);
        // 如果只加锁不解锁 那么在调用就会发生死锁现象。
    } else {
        // Fallback on earlier versions
        [self osspinlock];
    }
    
}
 
- (void)pthread_mutex {
    // 初始化锁(这是结构题变量) 注意：加锁再次进行加锁的时候就会造成死锁。
    //pthread_mutex 是一个互斥锁，如果用另外一种方式创建锁的时候，设置其属性是递归的时候就不会造成死锁。
    pthread_mutex_t mutexLock = PTHREAD_MUTEX_INITIALIZER;
    // 加锁
    pthread_mutex_lock(&mutexLock);
    // 执行任务
    [self doSomething];
    // 解锁
    pthread_mutex_unlock(&mutexLock);
    // 不用了 就销毁
    pthread_mutex_destroy(&mutexLock);
    
}

// pthread的递归调用
- (void)pthread_mutex_recurecursive {
    
    // 递归调用 由于属性设置为递归即可
    pthread_mutex_lock(&_pthreadLock);
    // 这里得有条件控制跳出 否则就会一直执行
    static int count = 0;
    count++;
    if (count < 10) {
        [self pthread_mutex_recurecursive];
    }
    pthread_mutex_unlock(&_pthreadLock);

}

- (void)doSomething {
    NSLog(@"处理事情");
}

- (void)pthread_attr_init {
    
   //  递归锁:允许同一个线程对一把锁进行重复加锁
      // pthread属性声明
      pthread_mutexattr_t attr;
       // pthread属性初始化
      pthread_mutexattr_init(&attr);
      // 属性设置
      pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
      // 锁初始化
      pthread_mutex_init(&_pthreadLock, &attr);
      // 销毁属性
      pthread_mutexattr_destroy(&attr);
}


- (void)pthread_condation {
    // 两个线程
    [[[NSThread alloc]initWithTarget:self selector:@selector(__removeObject) object:nil] start];
    
    [[[NSThread alloc]initWithTarget:self selector:@selector(__addObject) object:nil] start];
    
}

- (void)__addObject {
    // 加锁
    pthread_mutex_lock(&_pthreadLock);
    // 执行任务
    [self.data addObject:@"1"];
    NSLog(@"添加了元素");
    //  通知wait去执行，唤醒wait这个api。这个时候继续添加锁.wait之后的方法继续执行。
    pthread_cond_signal(&_cond);
    // 如果唤醒所有线程的话 可以用api  pthread_cond_broadcast(&_cond); 激活所有等待条件的线程
   
    // 解锁
    pthread_mutex_unlock(&_pthreadLock);
}

- (void)__removeObject {
    
    NSLog(@"执行删除操作");
    // 加锁
    pthread_mutex_lock(&_pthreadLock);
    if (self.data.count == 0) {
        // 等待 进入休眠 释放锁unlock
        pthread_cond_wait(&_cond, &_pthreadLock);
    }
    // 执行任务
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    // 解锁
    pthread_mutex_unlock(&_pthreadLock);
}

- (void)nslockMethod {
    
    [self.lock lock];
    [self doSomething];
    [self.lock unlock];
    
}

- (void)nscondationMethod {
    // 两个线程
    [[[NSThread alloc]initWithTarget:self selector:@selector(__condationRemove) object:nil] start];
    
    [[[NSThread alloc]initWithTarget:self selector:@selector(__condationAdd) object:nil] start];
}


- (void)__condationAdd {
    // 加锁
    [self.condation lock];
    // 执行任务
    [self.data addObject:@"1"];
    NSLog(@"添加了元素");
    //  通知wait去执行，唤醒wait这个api。这个时候继续添加锁.wait之后的方法继续执行。
    [self.condation signal];
    // 如果唤醒所有线程的话 可以用api   [self.condation broadcast]; 激活所有等待条件的线程  广播
    // 解锁
    [self.condation unlock];
}

- (void)__condationRemove  {
    NSLog(@"执行删除操作");
    // 加锁
    [self.condation lock];
    if (self.data.count == 0) {
        // 等待 进入休眠 释放锁unlock
        [self.condation wait];
    }
    // 执行任务
    [self.data removeLastObject];
    NSLog(@"删除了元素");
    // 解锁
    [self.condation unlock];
}



- (void)threadLifeCycleTest {
    self.currentThread = [[NSThread alloc]initWithBlock:^{
        NSLog(@"11111");
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop]run];
    }];
    [self.currentThread start];
    //  下面的代码不会执行 因为线程的任务一旦调用完毕，生命周期就结束，无法在使用。要想可以使用 就打开上面的代码。上面的代码的意思是把当前线程阻塞。 准确的来说，使用runloop是为了让线程保持激活状态。
    [self performSelectorOnMainThread:@selector(threadTest01) withObject:nil waitUntilDone:NO];
    // 主线程几乎所有的事情都交给了runloop去做，比如界面的刷新，点击事件的处理。 performselector等。
    
    
}

- (void)threadTest01 {
    NSLog(@"22222");
}

- (void)nscondationLockMethod {
    // 开启两个两个线程
    [[[NSThread alloc]initWithTarget:self selector:@selector(__condationLockRemove) object:nil] start];
    [[[NSThread alloc]initWithTarget:self selector:@selector(__condationLockAdd) object:nil] start];
}

- (void)__condationLockAdd {
    [self.condationLock lockWhenCondition:1];
    [self.data addObject:@"1"];
    [self.condationLock unlockWithCondition:2];
}

- (void)__condationLockRemove {
    
    [self.condationLock lockWhenCondition:2];
    [self.data removeLastObject];
    [self.condationLock unlock];
    
}
// 直接使用gcd的串行队列，也是可以实现线程同步的
- (void)threadSerial {
    
    dispatch_queue_t queue = dispatch_queue_create("com.serialqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"任务1");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务3");
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"任务4");
    });
    
}

- (void)dispatch_semaphoreMethod {
    // 控制最大并发数量
    for (int i = 0; i< 20; i++) {
        [[[NSThread alloc]initWithTarget:self selector:@selector(dispatch_semaphoreTestMethod) object:nil] start];
    }
}

- (void)dispatch_semaphoreTestMethod {
    // 如果信号量的值大于0，就让信号量的值减1 然后继续执行代码。wait 减1. signal 会加1
    // 如果信号量小于等于0 就会进入等待。直到信号量的值变成大于0。然后继续执行下面的代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    // 执行任务
    NSLog(@"线程：%@",[NSThread currentThread]);
    // 让信号量的值加1
    dispatch_semaphore_signal(self.semaphore);
}


- (void)synchronizedMethod {
    // 线程同步 其中self是锁对象。如果传的对象不一致，那么不是同一把锁。如果不是同一把锁那么可能就锁不住对象。 如果有其他对象在操作这个锁，那么他就会进入等待。
    @synchronized (self) {// objc_sync_enter
        NSLog(@"synchronized");
    }//objc_sync_exit
// 底层是hashmap实现 以 传入的参数为key 根据这个key 找到对应的mutex锁
}
- (void)dealloc {
    // 销毁锁
    pthread_mutex_destroy(&_pthreadLock);
    // 销毁条件
    pthread_cond_destroy(&_cond);
}
@end
/*
 面试题解答：使用多线程应该注意哪些问题？怎么解决？
  答：一块资源可能会被多个资源共享，也就是多线程可能会访问同一块资源。比如多个线程访问同一个对象，同一个变量，同一份文件。
     解决方案使用线程同步技术，同步，就是协同同步，按预定的先后次序进行。
     常见的线程同步技术就是加锁。
 */
// 面试题解答：iOS有哪些锁？你都使用过哪些？他们的应用场景是什么？
/*
 1.OSSpinLock
 2.os_unfair_lock
 3.pthread_mutex
 4.dispatch_semaphore
 5.dispatch_queue(DISPATCH_QUEUE_SERIAL)
 6.NSLock
 7.NSRecursiveLock
 8.NSCondition
 9.NSCondationLock
 10.@synchronized
 
 加锁的条件是两个线程都在访问公共的资源。
 
 1.OSSpinLock是自旋锁，当前锁被加锁的时候，等待锁的进程会处于忙等状态。一直占用cpu资源。
           会一直访问当前锁，当锁解锁之后，会对当前锁进行加锁，执行任务之后进行解锁。
 
 OSSpinLock目前已经不安全了，可能会出现优先级反转的问题。  可以参考时间片轮转调度算法
 如果优先级低的线程持有了锁(并未解锁)，如果优先级高的线程要访问锁。自旋锁会一直分配时间进行忙等，等解锁。会占用CPU资源，优先级低的线程会释放不了锁。那么就会发生死锁。
 还有一个api是OSSpinLockTry(&_osspinklock) 他会尝试加锁，如果可以加锁就加，不能加锁就不加。需要导入头文件  #import <libkern/OSAtomic.h>
 
 2.os_unfair_lock 用于取代OSSpinLock iOS 10+以后开始支持。
 从底层调用来看，等待os_unfair_lock锁的线程会处于休眠状态不是处于忙等。
 还有一个api是os_unfair_lock_trylock(&lock); 他会尝试加锁，如果可以加锁就加，不能加锁就不加。需要导入头文件  #import <os/lock.h>
 
 3.pthread_mutex  互斥锁，等待锁的时候处于休眠状态。 Low  level  lock低级锁，如果发现当前锁已经被加锁了，那么就会进入休眠等待。  使用场景 ：处理线程等待处理
 4.dispatch_semaphore  信号量。信号量有初始值。这个初始值是为了控制线程的最大并发数量。
 5.dispatch_queue(DISPATCH_QUEUE_SERIAL)  串行队列实现了类似锁的东西，顺序执行。
 6.NSLock 普通锁  可以通过查看汇编代码  底层实现是pthread_mutex_t 设置的属性是默认的 互斥锁。
 7.NSRecursiveLock递归锁，是对pthread_mutex_t的一个封装,只不过设置的属性是递归的。 递归锁  用法和NSLock基本一致。
 8.NSCondition 是对pthread_mutex_t和 pthread_condation_t的一个封装   里面有singal和wait方法
 9.NSCondationLock 是对NSCondition的进一步封装。可以封装条件值。
 10.@synchronized  是对mutex递归锁的封装 效率低。一般用于单例加锁的书写
 */

/*
 首先从性能来说
 os_unfailLock
 osspinlock
 dispatch_semphore
 pthread_mutex
 dispatch_queue(DISPATCH_QUEUE_SERIAL)
 NSLock
 NSCondation
 pthread_mutex(recursive)
 NSRecursiveLock
 NSCondationLock
 @synchronized
 推荐使用dispatch_semphore和pthread_mutex
 */
// 面试题解答：自旋锁和互斥锁有什么区别？
/*
   答：
 
 
 
 */
 
