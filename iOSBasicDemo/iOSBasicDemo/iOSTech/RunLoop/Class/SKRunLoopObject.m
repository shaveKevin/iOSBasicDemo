//
//  SKRunLoopObject.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/11.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRunLoopObject.h"

@interface SKRunLoopObject ()

@property (nonatomic, assign) NSInteger  timerNumber;

@end
@implementation SKRunLoopObject


- (instancetype)init {
    
    if (self = [super init]) {
        NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
        self.timerNumber = 0;
        NSLog(@"currentLoop is === %@",currentLoop);
    }
    return self;
}

- (void)runtimeTest {
    // 这个时候mode是defaultmode  scrollview 触发滚动时候不执行
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(printLogRef) userInfo:nil repeats:YES];
    //
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(printLogRef) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    if (self.timerNumber > 200) {
        // fire 是触发该定时器
//        [timer fire];  定时器需要暂停的时候可以把时间设置在未来的某一段时间 然后在把时间设置为现在就可以了
        // 停止  NSTimer 可以精确到50-100ms
        [timer invalidate];// 这个可以将计时器从runloop中移除。
        timer = nil;
    }
}

- (void)printLogRef {
    self.timerNumber++;
    NSLog(@"==========%@===============",@(self.timerNumber));
 
}


- (void)asycThreadMethod {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(asycTimerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        // 注意这里线程是在子线程 只有在主线程runloop才默认打开。这里需要获取到当前线程然后开启runloop.
        [[NSRunLoop currentRunLoop] run];
    });
    // runloop 用来循环处理响应事件，每个线程都有一个runloop。apple不允许自己创建runloop而且只有主线程的runloop是默认打开的。其他线程的runloop需要使用就必须手动打开。scheduledTimerWithTimeInterval这个方法创建好NSTimer以后会自动将它添加到当前线程的runloop中，非主线程只有调用run方法定时器才能开始工作。
}

- (void)asycTimerAction {
    
}

// 添加observer监听runloop的所有状态
- (void)runloopAddobserve {
    //创建
    CFRunLoopObserverRef oberver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, CFRunLoopObserverCallBackMethod, NULL);
    //添加观察者
    CFRunLoopAddObserver(CFRunLoopGetMain(), oberver, kCFRunLoopCommonModes);
    // 释放观察者
    CFRelease(oberver);
    
}

- (void)runloopAddobserveMethod {
    CFRunLoopObserverRef oberver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
             case kCFRunLoopEntry:
             {
                 NSLog(@"kCFRunLoopEntry");
                 // c语言copy和create出来的需要release
                 CFRunLoopMode mode =  CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                 NSLog(@"kCFRunLoopEntry = %@",mode);
                 CFRelease(mode);
             }
                 break;
             case kCFRunLoopBeforeTimers:
             {
                 NSLog(@"kCFRunLoopBeforeTimers");
             }
                 break;
             case kCFRunLoopBeforeSources:
             {
                 NSLog(@"kCFRunLoopBeforeSources");
             }
                 break;
             case kCFRunLoopBeforeWaiting:
             {
                 NSLog(@"kCFRunLoopBeforeWaiting");
             }
                 break;
             case kCFRunLoopAfterWaiting:
             {
                 // 唤醒
                 NSLog(@"kCFRunLoopAfterWaiting");
             }
                 break;
             case kCFRunLoopExit:
             {
                 NSLog(@"kCFRunLoopExit");
             }
                 break;
                 
             default:
                 break;
         }
    });
    // 添加到runloop
    CFRunLoopAddObserver(CFRunLoopGetMain(), oberver, kCFRunLoopCommonModes);
    // 释放
    CFRelease(oberver);
}

void CFRunLoopObserverCallBackMethod(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    switch (activity) {
        case kCFRunLoopEntry:
        {
            NSLog(@"kCFRunLoopEntry");
            // c语言copy和create出来的需要release
            CFRunLoopMode mode =  CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
            NSLog(@"kCFRunLoopEntry = %@",mode);
            CFRelease(mode);
        }
            break;
        case kCFRunLoopBeforeTimers:
        {
            NSLog(@"kCFRunLoopBeforeTimers");
        }
            break;
        case kCFRunLoopBeforeSources:
        {
            NSLog(@"kCFRunLoopBeforeSources");
        }
            break;
        case kCFRunLoopBeforeWaiting:
        {
            NSLog(@"kCFRunLoopBeforeWaiting");
        }
            break;
        case kCFRunLoopAfterWaiting:
        {
            // 唤醒
            NSLog(@"kCFRunLoopAfterWaiting");
        }
            break;
        case kCFRunLoopExit:
        {
            NSLog(@"kCFRunLoopExit");
        }
            break;
            
        default:
            break;
    }
    
}

@end

//  面试题解答：1.runloop和线程有什么关系？

/*

  总的来说，RunLoop正如其名，loop表示一种循环，和run放在一起就表示一直运行着的循环。实际上，runloop和线程是紧密相连的。
  可以这样说runloop是为了线程而生，没有线程，它就没有存在的必要。run loops是线程的基础架构部分，cocoa和corefundation都提供了run loop对象
  方便配置和管理线程run loop。 每个线程，包括程序的主线程 多有与之相对应的run loop 对象。
  runloop和线程的关系
 
  1.主线程的runloop默认是启动的。
  在iOS 的应用程序里面，程序启动后会有一个如下的main函数
 ```
  int main(int argc, char * argv[]) {
      @autoreleasepool {
          return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
      }
  }
 ```
  重点是这个UIApplicationMain()函数，这个方法会为main thread 设置一个NSRunLoop对象，这就解释了：为什么我们可以应用在无人操作的时候休息。需要它干活的时候又能马上响应。
 
   2.对于其他线程来说，runloop默认是没有启动的。在第一次获取的时候创建。如果你需要更多的线程交互则可以手动配置和启动。如果线程只是去执行长时间的已确定的任务则不需要。
 
   3.在任何一个cocoa程序的线程中，都可以通过下面的代码来获取当前线程的runloop
   `NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];`
   4.runloop会现在线程结束的时候销毁。
 
 附加：
 runloop保存在一个全局的dictionary中，线程作为key，runloop作为value。
 与runloop相关的有五个类
 cfRunloopref
 cfrunloopmoderef
 cfrunloopsourceref
 cfrunlooptimerref
 cfrunloopobserverref
 
 
 CFRunloopModeRef代表了Runloop的运行模式。
 一个runloop包含若干个Mode，每个mode又包含若干个source0 source1 source2 observer
 runloop启动时只能选择一个mode。作为currentmode
 如果要切换mode  只能退出当前loop  再重新选择一个mode进入。
 不同组的Source0/Source1/Timer/Observer能分隔开来，互不影响
 如果Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出
 
 Source0 处理的事件
 1.触摸事件
 2.performselector:onthread
 (处理app内部事件，app自己负责管理(触发),比如：UIEvent CFSocket)
 
 Source1
 1.基于port的线程间通信
 2.系统时间捕捉
 (由runloop和内核管理，mach port驱动，如:CFMachPort、CFMessagePort)
 
 Timers
 1.NSTimer
 2.performselector:afterDelay
 
 Observers
 1.用于监听Runloop的状态
 2.UI刷新(beforewaiting)
 3.autoreleasepool
 
 
参考链接：
        Objective-C之run loop详解:https://blog.csdn.net/wzzvictory/article/details/9237973
 */

//  面试题解答：2.runloop的mode作用是什么？

/*
 答： mode主要是用来指定时间运行循环中的优先级的。主要分为以下几个：
     * NSDefaultRunLoopMode (kCFRunLoopDefaultMode): 默认，空闲状态
     * UITrackingRunloopMode:scrollview 滑动的时候保证界面滑动不受其他mode影响
     * UIInitializationRunLoopMode: 启动的时候(私有)
     * NSRunLoopCommonModes （mode 集合）
     
    苹果提供的公开API有两个：
     1. NSDefaultRunLoopMode (kCFRunLoopDefaultMode)
     2. NSRunLoopCommonModes (kCFRunLoopCommonModes)// 用来标记一个操作为common的字符串，并不是真正的模式。使用他的时候表明了 timer在设置了common标记的模式下都可以运行。
 // timer能在_commonModes集合下所有的模式中运行
 
 */

// 其他： 
/*
    1.主线程的runloop自动创建，子线程的runloop默认不创建(在子线程中调用`NSRunLoop *currentLoop = [NSRunLoop currentRunLoop]` 获取runloop对象的时候，就会创建runloop)
    
    2.runloop退出的条件：app退出，线程关闭；设置最大时间到期。modeItem为空。
    3.同一时间一个runloop只能在一个mode，切换mode只能退出runloop，再重进指定mode(隔离modeitems使之互不干扰)
    4.一个item 可以被添加到不同的mode 一个mode被标记到commonModes里（这样runloop不用切换mode）
 
    每当runloop的内容发生变化时，runloop都会自动将_commonModeItems里的source/observe/timer同步到具有common标记的所有mode里。
 
   有时候你需要一个timer，在两个mode中都能得到回调，一种方法就是将这个timer分别加入到这两个mode。还有一种方式，就是将timer加入到顶层的runloop的commonModeItems。 这样commonModeItems被runloop自动更新到所有具有common属性的mode里去。
 
  可以参考链接：https://blog.csdn.net/jeffasd/article/details/52022460
 */

//  面试题解答：3.以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？

/*
  runloop只能运行在一种mode下，如果要切换mode，当前的loop需要停下来重启生成新的。利用这个机制，scrollview在滚动过程中，NSDefaultLoopMode(kCFRunLoopDefaultMode)的mode会切换到UITrackingRunLoopDefaultMode来保证scrollview的流畅滑动。只能在NSDefaultRunLoopMode模式下处理的时间会影响scrollview的滑动。
      如果我们把一个NSTimer对象以NSDefaultRunLoopMode(kCFRunloopDefaultMode)添加到主运行循环中的时候，scrollview滚动过程会因为mode的切换，而导致NSTimer将不再被调度。
 同时因为mode还是可以定制的；所以。timer及时会被scrollview的滑动影响的问题可以通过将timer添加到NSRunloopCommonModes（kCFRunLoopCommonModes）来解决。
 
 如果NSTimer当前处于NSDefaultRunLoopMode中，此时界面上有滚动事件发生，则RunLoop会瞬间切换至UITrackingRunLoopMode模式。这意味着NSTimer会被暂停调用响应方法，直至滚动事件被处理完，当滚动事件被处理完后，RunLoop又会被瞬间切换至NSDefaultRunLoopMode模式，此时线程会查看该mode下是否有相应事件等待处理，有则继续，没有的话，runloop会进入休眠状态，直至被事件再次唤醒。
 占位mode：NSRunLoopCommonModes，它包含以上两种mode，处于该mode下的事件会在两种mode下都有效。也即mode切换过程中不会中断事件的处理。
 如果想让NSTimer同时在两种mode下都有效，该怎么办呢？
 答：要么将该NSTimer单独添加至两种mode下，要么一次性加入两种mode下NSRunLoopCommonModes。
 Mode应用场景：轮播时，如果想拖拽查看某一页时暂停定时器；上下滑动UITableView时，不影响分页滚动界面的自动滚动。
 正常情况下，轮播时，定时器会自动暂停等待，不需要额外的暂停操作，但是当拖拽事件结束后，会发现恢复自动滚动瞬间，滚动的比较快，影响体验；所以正确的做法是先invalidate & nil,拖拽结束后再重新创建NSTimer。

 可以参考链接：iOS趣味篇：NSTimer到底准不准？ https://www.jianshu.com/p/d5845842b7d3 
 */

//  面试题：4.猜想runloop内部是如何实现的？
/*
  答：一般来说，一个线程一次只能执行一个任务，执行完成后线程会退出。如果我们需要一个机制，让线程能随时处理事件但并不退出，通常的代码逻辑是这样的。
 ```
 function loop (){
     initialize();
     do {
         var message = get_next_message();
         process_message(message);
     } while(message!= quit)
 }
 ```
 或者使用伪代码来展示：
```
 int main (int argc, char *argv[]) {
     // 程序一直运行状态
     while (AppIsRunning) {
         // 处于睡眠状态，。等待唤醒
         id whoWakeMe = SleepForWakingUp();
         // 获取唤醒事件
         id event = GetEvent(whoWakeMe);
         // 开始处理唤醒事件
         HandleEvent(event);
         return 0;
     }
 }
```
 可参考： CFRunLoop https://github.com/ming1016/study/wiki/CFRunLoop
         RunLoop源码学习  https://blog.csdn.net/M316625387/article/details/83178369
 */

// 面试题解答：5.runloop有什么应用?
/*
 答：1.控制线程的生命周期(线程保活，例如AFNetworking)
    2.解决NSTimer在滑动停止工作的问题
    3.监控应用卡顿
    4.性能优化
 */
//  面试题解答：6.如何实现一个持久的线程?
/*
 答：采用runloop来实现。
 */

// runloop基本作用：
/*
 答: 保持程序的持续运行
    处理app的各种事件
    节省cpu资源，提高程序的性能：该做事的时候做事，该休息的时候休息。
 // 获取当前runloop对象
  NSRunLoop *runloop = [NSRunLoop currentRunLoop];
  CFRunLoopRef runloopRef = CFRunLoopGetCurrent();
 */

//
/* __CFRunLoopMode 源码
 struct __CFRunLoopMode {
     CFRuntimeBase _base;
     pthread_mutex_t _lock;
     CFStringRef _name;
     Boolean _stopped;
     char _padding[3];
     CFMutableSetRef _sources0;
     CFMutableSetRef _sources1;
     CFMutableArrayRef _observers;
     CFMutableArrayRef _timers;
     CFMutableDictionaryRef _portToV1SourceMap;
     __CFPortSet _portSet;
     CFIndex _observerMask;
 #if USE_DISPATCH_SOURCE_FOR_TIMERS
     dispatch_source_t _timerSource;
     dispatch_queue_t _queue;
     Boolean _timerFired; // set to true by the source when a timer has fired
     Boolean _dispatchTimerArmed;
 #endif
 #if USE_MK_TIMER_TOO
     mach_port_t _timerPort;
     Boolean _mkTimerArmed;
 #endif
 #if DEPLOYMENT_TARGET_WINDOWS
     DWORD _msgQMask;
     void (*_msgPump)(void);
 #endif
     uint64_t _timerSoftDeadline;
     uint64_t _timerHardDeadline;
 };
 */
//  runloop运行逻辑
/*
 1.通知obervers：进入loop
 2.通知obervers：即将处理timers
 3.通知obervers：即将处理sources
 4.处理blocks
 5.处理source0(可能会再次处理blocks)
 6.如果存在source1，跳转到第8步。
 7.通知observers：开始休眠(等待消息唤醒)
 8.通知observers：结束休眠(被某个消息唤醒)
 -01.处理timer
 -02.处理gcd asynct to main queue
 -03.处理source1
 9.处理blocks
 10.根据前面执行结果，决定如何操作
 -01.回到第2步
 -02.退出loop
 11.通知obervers：退出loop

 */
