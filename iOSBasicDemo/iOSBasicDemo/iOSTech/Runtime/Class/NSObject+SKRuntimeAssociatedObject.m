//
//  NSObject+SKRuntimeAssociatedObject.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "NSObject+SKRuntimeAssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (SKRuntimeAssociatedObject)

- (void)setTimeValue:(NSString *)timeValue {
    objc_setAssociatedObject(self, @"timeValue", timeValue, OBJC_ASSOCIATION_COPY);
    
}

- (NSString *)timeValue {
    return  objc_getAssociatedObject(self, @"timeValue");
}

- (void)setWeakVC:(UIViewController *)weakVC {
    objc_setAssociatedObject(self, @"weakWeakVC", weakVC, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)weakVC {
    return  objc_getAssociatedObject(self, @"weakWeakVC");
}

@end
// 面试题解答：使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？
/*
 答案是不需要。
 - 在wwdc2011 session 322中发布的内存销毁时间表，被关联的对象在生命周期内要比对象本身释放的要晚的多。
   他们会被NSObject-dealloc调用的objc_dispose()方法中释放。
 对象的内存销毁时间表分为四个步骤：
   1. 调用release： 引用计数变为0
    * 对象正在被销毁，声明周期即将结束
    * 不能再有新的__weak弱引用，否则将指向nil
    * 调用[self dealloc]
   2.子类调用 - dealloc
    * 继承关系中最底层的子类，在调用dealloc
    * 如果是mrc代码 则会手动释放实例变量们(ivars)
    * 继承关系的每一层父类，都在调用dealloc
   3. NSObject调用- dealloc
     * 只做一件事，调用OC runtime中的objc_dispose() 方法
   4. 调用objc_dispose()
      * 为c++ 的实例变量们(ivars) 调用destructors
      * 为arc状态下的的实例变量们调用 -release
      * 解除所有使用runtime Associate方法的关联对象。
      * 解除所有__weak的 引用
      * 调用free()
 */

// 面试题:runtime如何实现weak变量的自动置nil？
/*
 runtime 对注册的类，会进行布局，对于weak对象会放入一个hash表中。用weak指向的对象内存地址作为key，当次对象的引用计数为0的时候会dealloc
 假如weak指向的对象内存地址是a，那么就会以a为键，在这个weak表中搜索，找到所有以a为键的weak对象，从而设置为nil。
 
 ---------------------下面是一段伪代码------------------
 设计 objc_storeWeak(&a,b);// a是weak修饰的对象  b是赋值对象也即是属性变量 属于a下的属性变量
 objc_storeWeak函数把第二个参数 - 赋值对象(b)的内存地址作为key， 将第一个参数--weak修饰的属性变量(a)的内存地址(&a)作为value 注册到weak表中。
 如果第二个参数(b)为0(nil), 那么把变量(a)的内存地址(&a)从表中删除，你可以把objc_storeWeak(&a,b）理解为：objc_store(value, key) 并且当key变nil，将value置nil
 在b变非nil时，a和b指向同一个内存地址，在b变nil时，a变nil 此时向a发送消息不会崩溃：在oc中向nil 发送消息是安全的。
 如果a是由assign修饰的，则在b非nil的时候，a和b指向同一个内存地址，在b变nil时，a还是指向该内存地址，变野指针。此时向a发消息容易崩溃。
 // 伪代码：
 id obj1;
 objc_initWeak(&obj1,obj); (value,key)
 objc_destroyWak(&obj1);
 
 总体来说，作用是:通过objc_initWeak函数初始化“附有weak修饰符的变量(obj1)，在变量作用域结束时通过objc_destoryWeak函数释放该变量(obj1)
 //
  objc_initWeak 函数的实现是这样的，在将附有weak修饰符的变量obj1 初始化为0  nil 后，会将赋值对象obj作为参数，调用objc_storeWeak函数，
 obj1 = 0;
 objc_storeWeak(&obj1,obj);
 也就是说weak修饰的指针默认值是nil
 然后obj_destoryWeak 函数将0 nil作为参数，调用objc_storeWeak函数
 objc_storeWeak(&obj1, obj);
 
 下面和伪代码相同
 id  obj1;
 obj1 = 0;
 //
 objc_storeWeak(&obj1,obj);
 // obj 的引用计数为0 被置为nil
 objc_storeWeak(&obj1,0);
 obj_storeWeak函数把第二个参数-赋值对象(obj)的内存地址作为键值，将第一个参数--weak修饰的属性变量(obj1)的内存地址注册到weak表中。如果第二个参数obj为0或者nil 的时候，那么把变量obj1的地址从weak表中删除。
  对应的可以这样理解
 (这里假如weak修饰了self) __weak typeof(self)weakSelf = self; 其中self有一个属性叫 nameLabel
 
 
                  weak 表
 
        key                   value
        &self                 &self.nameLabel
 
 当self dealloc的时候self被置为nil 表中对应的value也被置为nil。从weak表中移除。

 */

// 面试题解答：能否向编译后得到的类增加实例变量？能否向运行时创建的类中添加实例变量，为什么？
/*
     答:不能向编译后得到的类增加实例变量；能向运行时创建的类中添加实例变量。
   因为编译后的类已经注册在runtime中，类结构体中的objc_ivar_list实例变量的列表和instance_size 实例变量的内存大小已经确定，同时runtime会调用
   class_setIvarLayout或class_setWeakivarLayout来处理strong weak引用。所以不能向存在的类添加实例变量。
    运行时创建的类是可以增加实例变量的，调用clas_addIvar函数。但是这得在调用objc_allocateClassPair之后，objc_registerPiar之前。
 */

// 参考链接：
//1. Will An Associated Object Be Released Automatically? https://stackoverflow.com/questions/10842829/will-an-associated-object-be-released-automatically/10843510#10843510



