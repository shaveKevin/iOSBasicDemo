//
//  SKSlimObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/15.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSlimObj.h"

@implementation SKSlimObj

@end
// 面试题解答：app瘦身你做过哪些工作，用了哪些工具？
/**
 答：1.安装包（IPA）主要由可执行文件、资源组成
    资源（图片、音频、视频等）  采取无损压缩 去除没有用到的资源：
 2.可执行文件瘦身 编译器优化  Strip Linked Product、Make Strings Read-Only、Symbols Hidden by Default设置为YES
去掉异常支持，Enable C++ Exceptions、Enable Objective-C Exceptions设置为NO， Other C Flags添加-fno-exceptions
利用AppCode（https://www.jetbrains.com/objc/）检测未使用的代码：菜单栏 -> Code -> Inspect Code
编写LLVM插件检测出重复代码、未被调用的代码
 
LinkMap:可借助第三方工具解析LinkMap文件： https://github.com/huanxsd/LinkMap
 */
