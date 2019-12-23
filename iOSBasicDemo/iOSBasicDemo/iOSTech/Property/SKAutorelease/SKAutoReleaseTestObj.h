//
//  SKAutoReleaseTestObj.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 面试题:1.objc使用什么机制管理对象内存？
// 面试题:2.ARC通过什么方式帮助开发者管理内存？
// 面试题:3.不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）
// 面试题:4.苹果是如何实现autoreleasepool的？
// 面试题:5.什么时候需要使用autoreleaseopool来解决问题？用来解决什么问题？

@interface SKAutoReleaseTestObj : NSObject

@end

NS_ASSUME_NONNULL_END
