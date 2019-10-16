
//
//  SKAutoReleaseTestObj.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/10/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKAutoReleaseTestObj.h"

@implementation SKAutoReleaseTestObj

- (instancetype)init {
    
    if (self = [super init]) {
        @autoreleasepool {
        }
    }
    return self;
}

@end

// 面试题解答：1.objc使用什么机制管理对象内存？
/*
 答：objc管理对象内存的时候采用的是引用计数机制(retainCount)，在每次runloop的时候，都会检查对象的retaincount。如果retaincount为0，说明已经没有地方使用这个对象了。对象就要被释放(回收)。

 */
// 面试题解答:2.ARC通过什么方式帮助开发者管理内存？
/*
   答：ARC是automatic reference counting的缩写。和mrc相比，arc不仅仅是在编译期添加 retain/release/autorelease 那么简单。在编译器和运行期两部分共同帮助开发者管理内存。
 在编译器，arc用的是更底层的c接口实现的retain/release/autorelease,这样做性能更好，也是为什么不能在arc环境下手动retain/release/autorelease
 同时对同一上下文的同一对象成对retain/release操作进行优化(即忽略掉不必要的操作)；arc也包含运行期组件，这个地方做的优化比较复杂，但也不能被忽略。
 */

// 面试题解答:3.不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）

/*
 答：分两种情况：手动干预释放时机，系统自动释放。
 1. 手动干预释放时机：指定autoreleasepool就是所谓的：当前大括号结束时释放
 2. 系统自动去释放- 不手动指定autoreleasepool
  autorelease对象出了作用域之后，会被添加到最近一次创建的自动释放池中，并会在当前的runloop迭代结束时释放。(它能解释的原因是系统在每个runloop迭代中都加入了自动适当吃push和pop)
 释放的时机可以看图：(对象释放时机图.jpg)
  从程序启动到加载完成时一个完整的运行循环，然后会停下来，等待用户交互，用户的每一次交互都会启动一次运行循环，用来处理用户所有的点击事件，触摸事件。
  我们都知道：所有的autorelease对象，在出了作用域之后，会自动添加到最近创建的自动释放池中。 释放时机是当前的runloop迭代结束
  但是如果每次都放进引用程序的main.m中，迟早有被撑满的一刻，这个过程中必定有一个释放的动作，什么时候？
   在一个完整的运行循环结束之前，会被销毁。
 
   那么什么时间会创建自动释放池？
 运行循环检测到事件并启动后，就会创建自动释放池。
 
 从runloop的源码可知，子线程是默认没有runloop的。如果需要再子线程开启runloop，如果需要再子线程开启runloop，则需要调用[NSRunLoop CurrentRunLoop]方法，它内部实现是先检测
 线程，如果发现是子线程，以懒加载的形式创建一个子线程的runloop。并存储在一个全局的可变字典里，编程人员在调用[NSRunLoop CurrentRunLoop]时，是自动创建runloop的，而没办法手动创建。
  自定义的NSOperation和NSThread需要手动创建自动释放池，比如：自定义的NSOperation类中就必须添加自动释放池，否则出了作用域后，自动释放对象会因为没有自动释放池去处理它，而造成内存泄漏。
  
 但是对于blockOperation和NSThread
  
 */

// 面试题解答：5.什么时候需要使用autoreleaseopool来解决问题？用来解决什么问题？
/*
 答：需要显式使用@autoreleasepool{}一般有以下三种情况：
  1. autorelease 机制基于 UI framework。因此写非UI framework的程序时，需要自己管理对象生存周期。
  2. autorelease 触发时机发生在下一次runloop的时候。因此如何在一个大的循环里不断创建autorelease对象，那么这些对象在下一次runloop回来之前将没有机会被释放，可能会耗尽内存。这种情况下，可以在循环内部显式使用@autoreleasepool {}将autorelease 对象释放。
 例如：
        for ( id item  in  bigArray) {
          @autoreleasepool {
            // do  sth taste  time  耗时  耗内存操作 如果不写容易造成内存不足，因为这里可能产生大量autorelease对象，没有及时的release掉容易造成内存不释放
               }
          }

  3. 自己创建的线程。Cocoa的应用都会维护自己autoreleasepool。因此，代码里spawn的线程，需要显式添加autoreleasepool。注意：如果是使用POSIX API 创建线程，而不是NSThread，那么不能使用Cocoa，因为Cocoa只能在多线程（multithreading）状态下工作。但可以使用NSThread创建一个马上销毁的线程，使得Cocoa进入multithreading状态。
 
  参考链接：https://blog.csdn.net/guijiewan/article/details/46470285
 
 https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmAutoreleasePools.html
 
 延伸：为何线程的入口要加Autorelease Pool
 线程的生命周期：

 在任何一个时间点上，线程是可结合的（joinable），或者是分离的（detached）。一个可结合的线程能够被其他线程收回其资源和杀死；在被其他线程回收之前，它的存储器资源（如栈）是不释放的。相反，一个分离的线程是不能被其他线程回收或杀死的，它的存储器资源在它终止时由系统自动释放。

 线程的分离状态决定一个线程以什么样的方式来终止自己。在默认情况下线程是非分离状态的，这种情况下，原有的线程等待创建的线程结束。只有当pthread_join（）函数返回时，创建的线程才算终止，才能释放自己占用的系统资源。而分离线程不是这样子的，它没有被其他的线程所等待，自己运行结束了，线程也就终止了，马上释放系统资源。程序员应该根据自己的需要，选择适当的分离状态。所以如果我们在创建线程时就知道不需要了解线程的终止状态，则可以pthread_attr_t结构中的detachstate线程属性，让线程以分离状态启动。

 由此可知，线程占用的资源要释放的前提是线程终止，如果加了autoreleasepool相关对象会在pool执行完毕后释放，避免过多的延迟释放造成程序占用过多的内存。如果是一个长寿命的线程的话，应该创建更多的Autorelease Pool来达到这个目的。例如线程中用到了run loop的时候，每一次的迭代都需要创建Autorelease Pool。

 有一个疑问，如果分离线程在执行完会自动释放资源，避免了资源的延迟释放，那为什么apple 默认创建的线程不是分离的？其实笔者认为，Apple可能是考虑了线程之间的交互情况。譬如，A线程需要在B线程执行完之后再执行，如果B是可结合的线程,那么在B执行完后会调用pthread_join（）回调到原有线程；可是如果是分离线程的话，执行完就自动释放了，没有回调到原线程，无法进行交互。

 参考链接：https://blog.csdn.net/qq_22389025/article/details/85162240
 */
