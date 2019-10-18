//
//  NSObject+SKRuntimeAssociatedObject.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 面试题:使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？

// 面试题:runtime如何实现weak变量的自动置nil？

// 面试题:能否向编译后得到的类增加实例变量？能否向运行时创建的类中添加实例变量，为什么？

@interface NSObject (SKRuntimeAssociatedObject)

@property (nonatomic, copy) NSString *timeValue;

@property (nonatomic, weak) UIViewController *weakVC;

@end

NS_ASSUME_NONNULL_END
