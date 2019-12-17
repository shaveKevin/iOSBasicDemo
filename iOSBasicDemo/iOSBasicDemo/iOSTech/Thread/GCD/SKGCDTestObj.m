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
    }
    return self;
}

// 使用sync函数往当前串行队列中添加任务的时候，会产生死锁。
// 创建串行队列
- (void)createSerialQueue  {
    // 创建串行队列
    dispatch_queue_t secrialQueue = dispatch_queue_create("secrialQueue", NULL);
    // 使用串行队列
    dispatch_async(secrialQueue, ^{
        NSLog(@"串行队列输出1");
    });
    dispatch_async(secrialQueue, ^{
        NSLog(@"串行队列输出2");
    });
    dispatch_async(secrialQueue, ^{
        NSLog(@"串行队列输出3");
    });
    // 可以看出 输出是相对有序的 串行队列输出1 串行队列输出2 串行队列输出3 也是相对有序的
    // 异步 串行队列   顺序执行 异步只是说明 不会影响下面方法的执行。
}
// 创建并行队列
- (void)createConcurrentQueue {
    // 创建并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    // 使用并行队列
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列输出1");
        NSLog(@" 1.当前线程  %@",[NSThread currentThread]);
        
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列输出2");
        NSLog(@" 2.当前线程  %@",[NSThread currentThread]);
        
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列输出3");
        NSLog(@" 3.当前线程  %@",[NSThread currentThread]);
    });
    // 这里输出的顺序不确定。因为是并行队列，并行队列是多线程的，不需要等待 接到任务就开始执行。
    // 异步不会卡着下面方法的执行。并行队列没有固定谁先执行的顺序。所以执行顺序不定。
}
/*
  上面两个方法创建的队列的区别就在于第二个参数 NULL还是DISPATCH_QUEUE_CONCURRENT
  当我们创建并行队列时，线程的使用和数量是根据XNU内核来决定的，我们不需要担心。比如当前有c1和c2两个线程，当我们创建任务3的时候，系统发现c2中的任务执行完了。c1还在继续。就不会创建3而是把3放到c2执行
  但是当我们创建多个串行队列时，虽然能达到一个并行队列的并行效果，但是系统对每个串行队列都会生成一个新线程，这样会消耗内存，造成大量的上下文切换，降低系统的响应性能。
 */

- (void)createDispatchBarrierAsync {
    
    // 这里借助上面的输出无序的并行队列来验证barrier的作用(因为并行队列具有执行的无序性)
    dispatch_queue_t barrierQueue = dispatch_queue_create("barrierQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(barrierQueue, ^{
        sleep(5);
        NSLog(@"barrier之并行队列输出1");
    });
    dispatch_barrier_async(barrierQueue, ^{
        NSLog(@"barrier执行");
    });
    dispatch_async(barrierQueue, ^{
        NSLog(@"barrier之并行队列输出2");
    });
    dispatch_async(barrierQueue, ^{
        NSLog(@"barrier之并行队列输出4");
    });
    // 结论：通过barrier的执行你会发现barrier 之前的代码总是先执行 待barrier执行完之后才执行其他队列,即使输入的时候队列中第一个任务中虽然有延时，但是程序依然是等到执行完之后才去执行barrier以及以后的数据
  
}

- (void)createDispatchNotify {
    
  // 除了使用队列的形式来实现 我们还可以用group来实现上面的功能(通过这种方式也可以创建一个并行队列)  主线程的队列是串行的
    // 一般来说并行的队列用于处理数据以及其他 主线程的主队列用于处理UI的显示
    dispatch_queue_t groupQueue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, groupQueue, ^{
        NSLog(@"group任务1");
    });
    dispatch_group_async(group, groupQueue, ^{
        NSLog(@"group任务2");
    });
    dispatch_group_notify(group, groupQueue, ^{
        NSLog(@"notify=notify");
    });
    dispatch_group_async(group, groupQueue, ^{
           NSLog(@"group任务3");
       });
    // 任务1  2 3 的执行顺序是不定的。但是他们都在notify的后面执行。在同一个group中，只有任务全部执行完毕才会执行notify。注意这里的notify的队列可以不是group但是group一定是同一个。

}

// 使用notify和barrier的区别是：notify的任务中子任务的执行必须在同一group下。执行顺序notify永远在最后。 barrier使用过程中barrier之前添加的任务执行之后，才会执行barrier barrier之后的任务只是在barrier之后执行。barrier相当于一个跨栏的栏杆一样 跨过之后就一马平川了。
// 知识普及：什么是死锁？
/*
答：死锁是指两个或两个以上的进程在执行过程中，由于竞争资源或者由于彼此通信而造成的一种阻塞的现象，若无外力作用，它们都将无法推进下去。此时称系统处于死锁状态或系统产生了死锁，这些永远在互相等待的进程称为死锁进程。  ---  来自百度百科。
 简单的说，死锁就是线程相互等待。
 */

// 死锁：这里产生的原因是当当前的queue和targetqueue 一致时同步会导致死锁。
- (void)createDeadLock {
    dispatch_queue_t queueA = dispatch_queue_create("com.shavekevin.queueA", NULL);
    dispatch_queue_t queueB = dispatch_queue_create("com.shavekevin.queueB", NULL);
    dispatch_sync(queueA, ^{
        dispatch_sync(queueB, ^{
            dispatch_block_t block = ^{
                NSLog(@"Block");
            };
            func(queueA, block);
        });
    });
}
//  因死锁这里会发生crash
// 问题出在GCD队列本身是不可重入的，串行同步队列的层级关系，是出现问题的根本原因。为了防止类似的误用，在iOS6的时候废弃掉这个了。
void func(dispatch_queue_t queue, dispatch_block_t block) {
    if (dispatch_get_current_queue() == queue) {
        block();
    } else{
        dispatch_sync(queue, block);
    }
}
// 既然上面因为可重入造成死锁问题，那么怎么才能解决呢？
// 1.dispatch_queue_set_specific 标记队列  2.递归锁

// 1.dispatch_queue_set_specific 标记队列
- (void)queueSetSpecificFunc {
    //创建队列
    dispatch_queue_t queueA = dispatch_queue_create("queueA", NULL);
    dispatch_queue_t queueB = dispatch_queue_create("queueB", NULL);
    // 设置目标队列
    dispatch_set_target_queue(queueB, queueA);
    static int specifickey;
    CFStringRef specificValue = CFSTR("ququeMethod");
    // 为队列添加标识
    dispatch_queue_set_specific(queueA, &specifickey, (void *)specificValue, (dispatch_function_t)CFRelease);
    // 同步执行queueB
    dispatch_sync(queueB, ^{
        dispatch_block_t block = ^{
            //能执行
            NSLog(@"哈哈");
        };
        // 如果标识存在那么就执行block
        CFStringRef retievedValue = dispatch_get_specific(&specifickey);
        if (retievedValue) {
            block();
        }
        else {
            // 否则同步执行queueB
            dispatch_sync(queueB, block);
        }
    });
}

// 递归解除可重入造成死锁问题
- (void)reentrantMethod {
    // 执行完block解锁
    dispatch_queue_t queueA = dispatch_queue_create("com.shavekevin,queueA.test", NULL);
    dispatch_block_t block = ^{
        NSLog(@"通过递归锁解除可重入造成死锁问题");
    };
    dispatch_sync(queueA, ^{
        dispatch_reentrant(block);
    });
}

void dispatch_reentrant(void(^block)(void)) {
    static NSRecursiveLock *lock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSRecursiveLock alloc]init];
    });
    [lock lock];
    block();
    [lock unlock];
}

- (void)syncMainThread {
    
    NSLog(@"1");// 任务1
    // 同步主线程
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2");//任务2
    });
    NSLog(@"3");// 任务3
    //答案是仅仅输出1
    /*
     分析： 首先主线程执行到这里的时候，我们可以分析到dispatch_sync 这是一个同步的线程
        dispatch_get_main_queue 这是一个主线程中的主队列。 任务2 是同步线程的任务。
       执行任务1 没有什么问题，程序接着执行。遇到dispatch_sync同步线程的时候会进入等待。他会等待任务2 完成之后再继续执行下面的任务。
       这是一个队列，遵循FIFO 先进先出的规则，所以任务3 会排在任务2 的前面。 然后任务3 会等着任务2执行完毕之后才会执行，任务2又在任务3的后面，也就是说任务2会等着任务3执行完毕之后才能正常执行下去。所以他们进入了互相等待的局面。这就是所谓的死锁。
     
     任务1
     任务3
     任务2
     
     先执行遇到同步线程进入等待  然后任务3 进入任务队列。 之后任务2 加入队列  任务2执行完之后才能执行3.而任务3在任务2的前面。任务3之后任务2 执行完毕之后才能执行。。所以 任务2 等待任务3。任务3 等待任务2。。。 互相等待主线程就锁住了。
          */
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
  2.1 什么是并行队列：使用多个线程，任务无需等待，立即执行。
 // 注意：当多个任务都需要操作同一资源时，我们需要使用串行队列，防止数据竞争和死锁。
 */
// 参考链接：iOS-GCD的串行队列和并行队列的任务及实现 https://blog.csdn.net/c386890506/article/details/51171898
// iOS开发之多线程GCD详解  https://zhuanlan.zhihu.com/p/59219627

// 面试题解答： 2.dispatch_barrier_async的作用是什么？
/*
 答：在并行队列中，为了保持某些任务的顺序，需要等待一些任务完成后才能继续进行，使用 barrier 来等待之前任务完成，避免数据竞争等问题。 dispatch_barrier_async 函数会等待追加到Concurrent Dispatch Queue并行队列中的操作全部执行完之后，然后再执行 dispatch_barrier_async 函数追加的处理，等 dispatch_barrier_async 追加的处理执行结束之后，Concurrent Dispatch Queue才恢复之前的动作继续执行。
 
 */

// 面试题解答： 3.苹果为什么要废弃dispatch_get_current_queue？
/*
 答：因为它容易造成死锁。
 dispatch_get_current_queue函数的行为常常与开发者所预期的不同。 由于派发队列是按层级来组织的，这意味着排在某条队列中的块会在其上级队列里执行。 队列间的层级关系会导致检查当前队列是否为执行同步派发所用的队列这种方法并不总是奏效。dispatch_get_current_queue函数通常会被用于解决由不可以重入的代码所引发的死锁，然后能用此函数解决的问题，通常也可以用"队列特定数据"来解决。
  
 参考:被废弃的dispatch_get_current_queue https://blog.csdn.net/yiyaaixuexi/article/details/17752925
 */
// 知识百科：什么是可重入？
/*
 来自维基百科：若一个程序或子程序可以“安全的被并行执行(Parallel computing)”，则称其为可重入（reentrant或re-entrant）的。

 即当该子程序正在运行时，可以再次进入并执行它（并行执行时，个别的执行结果，都符合设计时的预期）。
 若一个函数是可重入的，则该函数：
 不能含有静态（全局）非常量数据
 不能返回静态（全局）非常量数据的地址
 只能处理由调用者提供的数据
 不能依赖于单实例模式资源的锁
 不能调用(call)不可重入的函数(有呼叫(call)到的函数需满足前述条件)
 */

// 面试题解答： 4.如何用GCD同步若干个异步调用？（如根据若干个url异步加载多张图片，然后在都下载完成后合成一张整图）。
/*
 答：这个问题用Gcd的notify能解决。例如上面的方法：createDispatchNotify，它的作用是 只有等一个组内的任务完成之后，才走最后的notify方法。这样满足条件。
   有一点需要修改的是实例代码中的queue 改成主线程会符合题意。
 */

// 面试题解答：5.以下代码运行结果如何？
/*
 - (void)viewDidLoad
 {
     [super viewDidLoad];
     NSLog(@"1");
     dispatch_sync(dispatch_get_main_queue(), ^{
         NSLog(@"2");
     });
     NSLog(@"3");
 }
 答：只会输出1， 因为主线程等待 发生死锁。
 */

// 知识科普：
/*
  1.线程和进程有什么区别？(以下来自维基百科)
  答：。线程（英语：thread）是操作系统能够进行运算调度的最小单位。大部分情况下，它被包含在进程之中，是进程中的实际运作单位。一条线程指的是进程中一个单一顺序的控制流，一个进程中可以并发多个线程，每条线程并行执行不同的任务。在Unix System V及SunOS中也被称为轻量进程（lightweight processes），但轻量进程更多指内核线程（kernel thread），而把用户线程（user thread）称为线程。
 线程是独立调度和分派的基本单位。线程可以为操作系统内核调度的内核线程，如Win32线程；由用户进程自行调度的用户线程，如Linux平台的POSIX Thread；或者由内核与用户进程，如Windows 7的线程，进行混合调度。

 同一进程中的多条线程将共享该进程中的全部系统资源，如虚拟地址空间，文件描述符和信号处理等等。但同一进程中的多个线程有各自的调用栈（call stack），自己的寄存器环境（register context），自己的线程本地存储（thread-local storage）。

 一个进程可以有很多线程，每条线程并行执行不同的任务。

 在多核或多CPU，或支持Hyper-threading的CPU上使用多线程程序设计的好处是显而易见的，即提高了程序的执行吞吐率。在单CPU单核的计算机上，使用多线程技术，也可以把进程中负责I/O处理、人机交互而常被阻塞的部分与密集计算的部分分开来执行，编写专门的workhorse线程执行密集计算，从而提高了程序的执行效率。
 

 */

