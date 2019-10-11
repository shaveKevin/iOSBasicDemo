//
//  SKRunLoopObject.m
//  AllKindOfThings
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
    }
}

- (void)printLogRef {
    self.timerNumber++;
    NSLog(@"==========%@===============",@(self.timerNumber));
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
 
   2.对于其他线程来说，runloop默认是没有启动的。如果你需要更多的线程交互则可以手动配置和启动。如果线程只是去执行长时间的已确定的任务则不需要。
 
   3.在任何一个cocoa程序的线程中，都可以通过下面的代码来获取当前线程的runloop
   `NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];`
 
参考链接：
        Objective-C之run loop详解:https://blog.csdn.net/wzzvictory/article/details/9237973
 */

//  面试题解答：2.runloop的mode作用是什么？

/*
 答： mode主要是用来指定时间运行循环中的优先级的。主要分为以下几个：
     * NSDefaultRunLoopMode (kCFRunLoopDefaultMode): 默认，空闲状态
     * UITrackingRunloopMode:scrollview 滑动的时候
     * UIInitializationRunLoopMode: 启动的时候(私有)
     * NSRunLoopCommonModes （mode 集合）
     
    苹果提供的公开API有两个：
     1. NSDefaultRunLoopMode (kCFRunLoopDefaultMode)
     2. NSRunLoopCommonModes (kCFRunLoopCommonModes)// 用来标记一个操作为common的字符串
 
 */

// 其他：
/*
    1.主线程的runloop自动创建，子线程的runloop默认不创建(在子线程中调用`NSRunLoop *currentLoop = [NSRunLoop currentRunLoop]` 获取runloop对象的时候，就会创建runloop)
    
    2.runloop退出的条件：app退出，线程关闭；设置最大时间到期。modeItem为空。
    3.同一时间一个runloop只能在一个mode，切换mode只能退出runloop，再重进指定mode(隔离modeitems使之互不干扰)
    4.一个item 可以被添加到不同的mode 一个mode被标记到commonModes里（这样runloop不用切换mode）
 
    每当runloop的内容发生变化时，runloop都会自动将_commonModeItems里的source/observe/timer同步到具有common标记的所有mode里。
 
   有时候你需要一个timer，在两个mode中都能得到回调，一种方法就是将这个timer分别加入到这两个mode。还有一种方式，就是讲timer加入到顶层的runloop的commonModeItems。 这样commonModeItems被runloop自动更新到所有具有common属性的mode里去。
 
  可以参考链接：https://blog.csdn.net/jeffasd/article/details/52022460
 */

//  面试题解答：3.以+ scheduledTimerWithTimeInterval...的方式触发的timer，在滑动页面上的列表时，timer会暂定回调，为什么？如何解决？

/*
  runloop只能运行在一种model下，如果要切换mode，当前的loop需要停下来重启生成新的。利用这个机制，scrollview在滚动过程中，NSDefaultLoopMode(kCFRunLoopDefaultMode)的mode会切换到UITrackingRunLoopDefaultMode来保证scrollview的流畅滑动。只能在NSDefaultRunLoopMode模式下处理的时间会影响scrollview的滑动。
      如果我们把一个NSTimer对象以NSDefaultRunLoopMode(kCFRunloopDefaultMode)添加到主运行循环中的时候，scrollview滚动过程会因为mode的切，而导致NSTimer将不再被调度。
 同时因为mode还是可以定制的；所以。timer及时会被scrollview的滑动影响的问题可以通过将timer添加到NSRunloopCommonModes（kCFRunLoopCommonModes）来解决。
 
 */

//  面试题：4.猜想runloop内部是如何实现的？
/*
  答：一般来说，一个线程一次只能执行一个任务，执行完成后线程会退出。如果我们需要一个机制，让线程能随时处理事件但并不退出，通常的代码逻辑是这样的。
 
 */
  
