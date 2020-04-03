
//
//  SKAutoReleaseTestObj.m
//  iOSBasicDemo
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
        NSArray *array = [NSArray arrayWithObjects:@1,@3, nil];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // 这里被一个局部@autoreleasepool包围着---- （这个没发现那里来的)
            NSLog(@"纳尼");
            
          
        }];
        
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
 在编译期，arc用的是更底层的c接口实现的retain/release/autorelease,这样做性能更好，也是为什么不能在arc环境下手动retain/release/autorelease
 同时对同一上下文的同一对象成对retain/release操作进行优化(即忽略掉不必要的操作)；arc也包含运行期组件，这个地方做的优化比较复杂，但也不能被忽略。
 */

// 面试题解答:3.不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）

/*
 答：分两种情况：手动干预释放时机，系统自动释放。
 1. 手动干预释放时机：指定autoreleasepool就是所谓的：当前大括号结束时释放
 2. 系统自动去释放- 不手动指定autoreleasepool
  autorelease对象出了作用域之后，会被添加到最近一次创建的自动释放池中，并会在当前的runloop迭代结束时释放。(它能解释的原因是系统在每个runloop迭代中都加入了自动适当push和pop)
 释放的时机可以看图：(对象释放时机图.jpg)
  从程序启动到加载完成是一个完整的运行循环，然后会停下来，等待用户交互，用户的每一次交互都会启动一次运行循环，用来处理用户所有的点击事件，触摸事件。
  我们都知道：所有的autorelease对象，在出了作用域之后，会自动添加到最近创建的自动释放池中。 释放时机是当前的runloop迭代结束
  但是如果每次都放进应用程序的main.m中，迟早有被撑满的一刻，这个过程中必定有一个释放的动作，什么时候？
   在一个完整的运行循环结束之前，会被销毁。
 
   那么什么时间会创建自动释放池？
 运行循环检测到事件并启动后，就会创建自动释放池。
 
 从runloop的源码可知，子线程是默认没有runloop的。如果需要再子线程开启runloop，如果需要再子线程开启runloop，则需要调用[NSRunLoop CurrentRunLoop]方法，它内部实现是先检测
 线程，如果发现是子线程，以懒加载的形式创建一个子线程的runloop。并存储在一个全局的可变字典里，编程人员在调用[NSRunLoop CurrentRunLoop]时，是自动创建runloop的，而没办法手动创建。
  自定义的NSOperation和NSThread需要手动创建自动释放池，比如：自定义的NSOperation类中就必须添加自动释放池，否则出了作用域后，自动释放对象会因为没有自动释放池去处理它，而造成内存泄漏。
  
 但是对于blockOperation和invaocationOperation 这种默认的operation，系统已经帮我们封装好了。不需要手动创建自动释放池。
 
  @autoreleasepool 当自动释放池被销毁或者耗尽的时候，会向自动释放池中所有的对象发送release消息，(当对象的引用计数为0的时候，就被释放掉了)释放自动释放池中的所有对象。
 
 如果在一个vc的viewdidlaod中创建一个autorelease对象。那么该对象会在viewdidappear方法执行前就被销毁了。
 这是因为vc在loadview的时候就add到window上，所以viewdidload和viewwillappear是在同一个runloop调用的。所以在viewwillappear上的时候这个autorelease的变量没有被销毁，依然存在。
 
 参考链接：黑幕背后的Autorelease http://blog.sunnyxx.com/2014/10/15/behind-autorelease/
 */

// 面试题解答:4.苹果是如何实现autoreleasepool的？
/*
 通过clang可以看到autoreleasepool是：
 ```
 extern "C" __declspec(dllimport) void * objc_autoreleasePoolPush(void);
 extern "C" __declspec(dllimport) void objc_autoreleasePoolPop(void *);

 struct __AtAutoreleasePool {
   __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
   ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
   void * atautoreleasepoolobj;
 };
 ```
 
 autoreleasepool是以一个队列数组的形式实现。主要通过下面三个函数完成。
 objc_autoreleasepoolPush
 objc_autoreleasepoolPop
 objc_autorelease
  看函数名可以知道，对autorelease分别执行push 和pop 销毁对象的时候执行的是release操作。
 举例说明：
 ```
 - (void)autorelaseTest {
     @autoreleasepool {
         SKPropertyTestModel *model = [[SKPropertyTestModel alloc]init];
         model.title = [NSString stringWithFormat:@"title is %@  ",@(1)];
     }
 }
 
 上面这段代码可以改写为

 - (void)autorelaseTest {
 
      {
    void  *autoreleasepoolobj  = objc_autoreleasePoolPush();
 // autoreleasepoolobj 就是哨兵对象
 // 你执行的代码
       SKPropertyTestModel *model = [[SKPropertyTestModel alloc]init];
      model.title = [NSString stringWithFormat:@"title is %@  ",@(1)];
 
 objc_autoreleasePoolPop(autoreleasepoolobj);
        }

  }
 
 在objc源码中可以发现, objc_autoreleasePoolPush();objc_autoreleasePoolPop();的实现是autoreleasepoopPage的实现。也就是说autoreleasepoolpage是对静态方法push和pop的封装。
```
 objc_autoreleasePoolPush(void)
 {
     return AutoreleasePoolPage::push();
 }

 void
 objc_autoreleasePoolPop(void *ctxt)
 {
     AutoreleasePoolPage::pop(ctxt);
 }
 ```
 autoreleasepoolpage是c++实现的一个类，通过源码NSObject类中 641行 class AutoreleasePoolPage  可以看出
 1.AutoreleasePoolPage 没有单独的结构，而是由若干个AutoreleasePoolPage以双向链表形式组合而成。(对应AutoreleasePoolPage源码中的` AutoreleasePoolPage * const parent;
    AutoreleasePoolPage *child;`  parent和child指针)
 2.AutoreleasePool是按照线程一一对应的。(在AutoreleasePoolPage结构体中pthread_t const thread; 这个thread指的是当前页线程，如果对象所占不仅仅是一个page那么一个thread可以存在 多个page)POOL_SENTINEL（哨兵对象）他只是nil的别名
 3.AutoreleasePoolPage每个对象都会开辟4096字节结存(也就是虚拟内存一页的大小)除了源码中给出的实例变量所占的空间，剩下的空间全部用来存储autorelease对象的地址(注意这里只是存的地址而已。。。) 如果添加的对象太多地址存储不下，那么就会开辟下一个page
 4.源码中的id *next 指针作为游标指向栈顶最新add进来的autorelease对象的下一个地址。
 5.magic 用于对当前 AutoreleasePoolPage 完整性的校验
 6.一个AutoreleasePoolPage的空间被占满的时候，会新建一个AutoreleasePoolPage对象，连接链表，后来的autorelease对象在新的page加入。
 所以向一个对象发送- autorelease消息，就是将这个对象加入到AutoreleasepoolPage的栈顶next指向的位置。
 
 
 释放时刻：
 每当进行一次objc_autoreleasePoolPush调用的时候，runtime向当前的AutoreleasePoolPage中add一个哨兵对象，值为0（也就是nil）
 objc_autoreleasePoolPush()的返回值是这个哨兵对象的地址，被objc_autoreleasePoolPop(哨兵对象)作为入参。
 
 1. 根据传入的哨兵对象的地址找到哨兵对象所在的page
 2. 在当前page中，将晚于哨兵对象的插入的所以autorelease对象发送一次release消息，并向回移动next到正确位置。
 3. 从最新加入的对象一直向前清理，可以向前跨越多个page，直到找到哨兵所在的page。
 
假如下面模拟的是哨兵对象以及其他对象在pool中的位置
 
丨---------------------丨
        page1
 1-1(假如这个为pop的时候对象的地址)
 1-2
 1-3
 1-4
 1-5
丨---------------------丨
 
丨---------------------丨
           page2
 2-1
 2-2
 2-3
 2-4 (假如这个为哨兵 也就是push的时候传入的)
 2-5
 丨---------------------丨
 如果进行pop 操作会对page1中所有对象 以及 page2中2-1 ~ 2-4之前的对象都发送一次release消息。
 //
在NSObject.mm中 有一个autorelease方法：
 ```
 static inline id autorelease(id obj)
 {
     assert(obj);
     assert(!obj->isTaggedPointer());
     id *dest __unused = autoreleaseFast(obj);
     assert(!dest  ||  dest == EMPTY_POOL_PLACEHOLDER  ||  *dest == obj);
     return obj;
 }
 ```
 其中有一个函数叫autoreleaseFast
 
 autorelease调用栈：
 - [NSObject autorelease]
 └── id objc_object::rootAutorelease()
     └── id objc_object::rootAutorelease2()
         └── static id AutoreleasePoolPage::autorelease(id obj)
             └── static id AutoreleasePoolPage::autoreleaseFast(id obj)
                 ├── id *add(id obj)
                 ├── static id *autoreleaseFullPage(id obj, AutoreleasePoolPage *page)
                 │   ├── AutoreleasePoolPage(AutoreleasePoolPage *newParent)
                 │   └── id *add(id obj)
                 └── static id *autoreleaseNoPage(id obj)
                     ├── AutoreleasePoolPage(AutoreleasePoolPage *newParent)
                     └── id *add(id obj)
 
 在调用autorelease的时候都会调用autoreleaseFast，那么和fast执行了什么操作呢？
 先看定义：
 ``
 static inline id *autoreleaseFast(id obj)
 {
    AutoreleasePoolPage *page = hotPage();
    if (page && !page->full()) {
        return page->add(obj);
    } else if (page) {
        return autoreleaseFullPage(obj, page);
    } else {
        return autoreleaseNoPage(obj);
    }
 }

 ```
  其中hotpage指的是当前正在使用的page。
 这里分为三种不同的情况
 1. 有hotpage并且hotpage不满的时候，这个时候后直接把需要autorelease对象添加到autoreleasepoolpage中
 2. 当有hotpage并且hotpage满的时候。这个时候会初始化一个新的页面 然后调用add方法把对象添加到autoreleasepoolpage中
 3. 没有hotpage的时候。这个时候回创建一个page 然后调用dd方法把对象添加到autoreleasepoolpage中

 参考链接：   1. 黑幕后的autorelease http://blog.sunnyxx.com/2014/10/15/behind-autorelease/

              2.自动释放池的前世今生 https://github.com/draveness/analyze/blob/master/contents/objc/%E8%87%AA%E5%8A%A8%E9%87%8A%E6%94%BE%E6%B1%A0%E7%9A%84%E5%89%8D%E4%B8%96%E4%BB%8A%E7%94%9F.md
 
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

// 附加：
/*
 看源码的时候看到了一个判断 if (isTaggedPointer()) return (uintptr_t)this;
 查了下这个Tagged Pointer

 参考链接： 聊聊伪指针 Tagged Pointer  https://www.jianshu.com/p/3176e30c040b
 源码中这个实现是这样的
 ```
 static inline bool
 _objc_isTaggedPointer(const void * _Nullable ptr)
 {
     return ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
 }
 ```
 
 */


/*
 self.dataArray =   [NSMutableArray array];
     self.dataArray =   [[NSMutableArray alloc]init];
 两个不同的是 在底层实现的mrc中 [NSMutableArray array] = [[[NSMutableArray alloc]init]autorelease]   在array方法中自己添加了autorelease方法。
 */

// 可以通过以下私有函数来查看自动释放池的情况  extern void _objc_autoreleasePoolPrint(void);

/*
 补充：在64bit中，引用计数可以直接存储在优化过的isa指针中，也可能存储在SideTable类中
 struct SideTable {
     spinlock_t slock;
     RefouuntMap refcnts;
     weak_table_t  weak_table;
 };
 refcnts是一个存放着对象引用计数的散列表
 
 当一个对象要释放时，会自动调用dealloc，接下的调用轨迹是
 dealloc
 _objc_rootDealloc
 rootDealloc
 object_dispose
 objc_destructInstance、free
 
 自动释放池
 自动释放池的主要底层数据结构是：__AtAutoreleasePool、AutoreleasePoolPage

 调用了autorelease的对象最终都是通过AutoreleasePoolPage对象来管理的
源码分析：clang @autoreleasepool
objc4源码：NSObject.mm
每个AutoreleasePoolPage对象占用4096字节内存，除了用来存放它内部的成员变量，剩下的空间用来存放autorelease对象的地址
 所有的AutoreleasePoolPage对象通过双向链表的形式连接在一起
 调用push方法会将一个POOL_BOUNDARY入栈，并且返回其存放的内存地址
 调用pop方法时传入一个POOL_BOUNDARY的内存地址，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY
id *next指向了下一个能存放autorelease对象地址的区域
Runloop和Autorelease
iOS在主线程的Runloop中注册了2个Observer
第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
第2个Observer
监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()
 */


