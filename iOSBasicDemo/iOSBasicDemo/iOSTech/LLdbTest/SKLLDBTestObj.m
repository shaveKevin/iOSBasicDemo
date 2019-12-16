
//
//  SKLLDBTestObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/23.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKLLDBTestObj.h"

@implementation SKLLDBTestObj

@end

// 面试题解答：1.如何调试BAD_ACCESS错误
/*
 答：1.重写NSObject在的responsesToSelector方法，然后会打印出出现BAD_ACCESS前访问的最后一个object
    2.设置Zombie xcode上方选项中选中 product-scheme-edit  scheme - Diagnostics 勾选enable zombie objects
    3.设置全局断点 定位问题
    4.同样在第2步的对应位置勾选 enable address sanitizer
 */
// 知识科普：AddressSanitizer是当程序分配一段你内存时，将此内存后面的一段内存也给冻结。标识为毒内存。当程序访问到毒内存的时候(越界访问) 就会抛出异常，并打印出相应的log信息。我们可以根据中断位置和log信息。识别bug。如果变量释放了，变量所占的内存也会标记为中毒内存。这个时候，访问这段内存同样会抛出异常(访问的是已释放的对象)。
// 面试题解答：2.lldb（gdb）常用的调试命令？
/*
答：1.breakpoint 设置断点定位到某函数
    2. n断点跳转到下一步
    3.po 打印出对象的desc
    4. p打印出对象
    5.expression 简写 exp可以修改值
    6.call 方法调用
    7.bt 打印出调用的堆栈 thread backtrace
    8.thread return 跳转当前方法的执行
    9.frame select 1 如果打印有10帧  跳转到第一帧
    10.frame variable 查看帧变量
    11.image lookup -address 查找崩溃位置
 
 */
// 参考链接：iOS之LLDB常用命令  https://www.jianshu.com/p/7fb43e0b956a
  
// 补充：
/*
 -ObjC, -all_load, -force_load
 ld链接静态库的时候，只有.a中的某个.o符号被引用的时候，这个.o才会被链接器写到最后的二进制文件里，否则会被丢掉，这三个链接选项都是解决保留代码的问题。

 • -ObjC 保留所有Objective C的代码

 • -force_load 保留某一个静态库的全部代码

 • -all_load 保留参与链接的全部的静态库代码
 
 
 reexport
 假设我有个动态库A，A会链接B，我希望其他链接A动态库也能直接访问到B的符号，从而隐藏B的实现，应该怎么做呢？

 答案就是：reexport。

 这点在libSystem上体现的尤为明显，libSystem.dylib reexport了像malloc，dyld，macho等更底层动态库的符号。
 
 */
