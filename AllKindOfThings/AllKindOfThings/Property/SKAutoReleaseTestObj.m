
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
        
    }
    return self;
}

@end

// 面试题解答：1.objc使用什么机制管理对象内存？
/*
 答：objc管理对象内存的时候采用的是引用计数机制(retainCount)，在每次runloop的时候，都会检查对象的retaincount。如果retaincount为0，说明已经没有地方使用这个对象了。对象就要被释放(回收)。

 */
// 面试题:2.ARC通过什么方式帮助开发者管理内存？
/*
   ARC是automatic reference counting的缩写。
 */


