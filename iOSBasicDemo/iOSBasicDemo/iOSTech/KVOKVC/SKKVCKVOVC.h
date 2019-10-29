//
//  SKKVCKVOVC.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 面试题：1.addObserver:forKeyPath:options:context:各个参数的作用分别是什么，observer中需要实现哪个方法才能获得KVO回调？
// 面试题：2.如何手动触发一个value的KVO?
// 面试题：3.若一个类有实例变量 NSString *_foo ，调用setValue:forKey:时，可以以foo还是 _foo 作为key？
// 面试题：4.KVC的keyPath中的集合运算符如何使用？
// 面试题：5.KVC和KVO的keyPath一定是属性么？
// 面试题：6.如何关闭默认的KVO的默认实现，并进入自定义的KVO实现？
// 面试题：7.apple用什么方式实现对一个对象的KVO？
// 面试题：8.KVC能否触发KVO？说明理由。

@interface SKKVCKVOVC : UIViewController

@end

NS_ASSUME_NONNULL_END
