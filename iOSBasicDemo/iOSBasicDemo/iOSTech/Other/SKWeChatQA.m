//
//  SKWeChatQA.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/20.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKWeChatQA.h"

//#define NSLog(FORMAT,...)fprint(stderr,"goodbye world\n")
//#define NSLog(x)printf("goodbye world\n")
//#define NSLog  NSLog(@"goodbye world");

@implementation SKWeChatQA

- (void)replacePrintWorld {
    
    // 第一种方法：对NSLog 进行重定义,这样影响了所有的NSLog输出，具有局限性.同时会有编译⚠️
    // 第二种方法：可以利用编译器的注释特性
NSLog(@"goodbye world");//\
NSLog(@"helloWorld");
    // 这个考察的是NSString的内存复制的方案。如果能找到对应的字符串所在的内存地址，那么更换这个内存地址对应的值就可以解决这个问题了。
    
    // 深入理解NSString
    /*
     NSString的内存分配实际上是很复杂的，可能分配在栈区 堆区和常量区。
     我们常以为@"foo" 这样的字符串是常量区(也成为常量存储区域， _TEXT区) 运行时不能改，内存区域的映射都是dylb干的。
     其实我们可以简单的理解为：NSString 是一个map结构，key存储在常量区，的确无法修改。但是value是一个静态变量，我们可以在运行时修改。
     */
    // 修改CFString _DATA段
    

}



@end
