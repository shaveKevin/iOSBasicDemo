//
//  SKRunLoopObject.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/10/11.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRunLoopObject.h"

@implementation SKRunLoopObject

- (instancetype)init {
    
    if (self = [super init]) {
        NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
        NSDefaultRunLoopMode
        NSLog(@"currentLoop is === %@",currentLoop);
    }
    return self;
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

//  面试题：2.runloop的mode作用是什么？

/*
 答：mode 主要是用来指定时间运行循环中的优先级的。分为：
     * NSDefaultRunLoopMode (kCFRunLoopDefaultMode): 默认，空闲状态
 
 */
