//
//  SKRuntimeObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRuntimeObj.h"
// (1<<1)左移一位 例如：0000010  (1<<2)  左移两位 0000100
@implementation SKRuntimeObj

@end
// 面试题解答：讲一下 OC 的消息机制
/*
 答：OC中的方法调用其实都是转成了objc_msgSend函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名)
 objc_msgSend底层有3大阶段
 消息发送（当前类、父类中查找）、动态方法解析、消息转发
 */


// 面试题：什么是Runtime？平时项目中有用过么？
/*
 答：OC是一门动态性比较强的变成语言。允许很多操作推迟到程序运行时再进行。
    OC的动态性就是由Runtime来支撑和实现的，Runtime是一套C语言的API，封装了很多动态性相关的函数
    平时编写的OC代码，底层都是转换成了Runtime API进行调用
 平常使用的一般有：
 利用关联对象（AssociatedObject）给分类添加属性
 遍历类的所有成员变量（修改textfield的占位文字颜色、字典转模型、自动归档解档）
 交换方法实现（交换系统的方法）
 利用消息转发机制解决方法找不到的异常问题
等等。
 */

// 什么是isa指针？
/*
 答：在arm64架构之前，isa是一个普通指针。存储着 class  meta-class 对象的内存地址。
    在arm64架构之后，对isa进行了优化，变成了一个共用体(union)<isa_t>结构，还是用更多的位域来存储更多信息。
 共用体的内部共同一段内存
 */
