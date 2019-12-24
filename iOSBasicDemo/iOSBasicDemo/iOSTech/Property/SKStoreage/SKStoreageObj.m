//
//  SKStoreageObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKStoreageObj.h"

@implementation SKStoreageObj

@end
// 面试题解答：请介绍下内存的几大区域。
/*
 答：由低到高依次是：保留区域(大小和平台有关)->代码段(text)->数据段(字符串常量  已初始化数据<定义及有值> 未初始化数据<定义无值>)->堆(heap)->栈(stack)->内核区域
 代码段：编译之后的代码
 数据段：
 字符串常量：比如NSString *str = @"123"
 已初始化数据：已初始化的全局变量、静态变量等
 未初始化数据：未初始化的全局变量、静态变量等
 
栈：函数调用开销，比如局部变量。分配的内存空间地址越来越小
堆：通过alloc、malloc、calloc等动态分配的空间，分配的内存空间地址越来越大
 */

