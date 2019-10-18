//
//  SKRuntimePerson.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRuntimePerson.h"
#import <objc/runtime.h>

@interface SKRuntimePerson ()

- (SKRuntimePerson *)personMethod;

- (SKRuntimePerson *)motherMethod;

- (void)foo;

@end

@implementation SKRuntimePerson

- (void)takeAction {
    SKRuntimePerson *p  =  [[SKRuntimePerson alloc]init];
// 向对象p发送一个返回值为nil的消息 之后再发送一个nil的消息 此时并不会crash 返回值 对象为nil
    SKRuntimePerson *motherInLow = [[p personMethod] motherMethod];
    NSLog(@"%@",motherInLow);
}

- (SKRuntimePerson *)personMethod {
    return nil;
}

- (SKRuntimePerson *)motherMethod {
    return  nil;
}

// 面试题解答：
/*
  1. 如果方法的返回值是一个对象，发送nil消息的时候将返回nil。不会闪退。
  2. 如果方法返回值为指针类型，其指针大小为小于或者等于sizeof(void *) float double long double 或者long long 类型标量发送给nil的消息返回0
  3. 如果方法返回值为结构体，发送给nil的消息将返回0，结构体的各个字段的值都是0.
  4. 如果方法的返回值不是上述提到的几种情况，那么发送给nil的消息的返回值将是未定义的。
 
  因为OC是动态语言，每个方法在运行时会被动态转为消息发送 即 objc_msgSend(receive,selector)
 
 objc 在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类的方法列表以及父类方法中寻找方法运行，然后在发送消息的时候，objc_msgSend方法不会返回值，所谓的返回内容都是具体调用执行的。这道题 如果在寻找对象isa指针就是0地址返回了。所以不会出现任何错误。
 
 */
// objc的源代码

 // runtime.h（类在runtime中的定义）
/*
 struct objc_class {
   Class isa OBJC_ISA_AVAILABILITY; //isa指针指向Meta Class，因为Objc的类的本身也是一个Object，为了处理这个关系，runtime就创造了Meta Class，当给类发送[NSObject alloc]这样消息时，实际上是把这个消息发给了Class Object
   #if !__OBJC2__
   Class super_class OBJC2_UNAVAILABLE; // 父类
   const char *name OBJC2_UNAVAILABLE; // 类名
   long version OBJC2_UNAVAILABLE; // 类的版本信息，默认为0
   long info OBJC2_UNAVAILABLE; // 类信息，供运行期使用的一些位标识
   long instance_size OBJC2_UNAVAILABLE; // 该类的实例变量大小
   struct objc_ivar_list *ivars OBJC2_UNAVAILABLE; // 该类的成员变量链表
   struct objc_method_list **methodLists OBJC2_UNAVAILABLE; // 方法定义的链表
   struct objc_cache *cache OBJC2_UNAVAILABLE; // 方法缓存，对象接到一个消息会根据isa指针查找消息对象，这时会在method Lists中遍历，如果cache了，常用的方法调用时就能够提高调用的效率。
   struct objc_protocol_list *protocols OBJC2_UNAVAILABLE; // 协议链表
   #endif
   } OBJC2_UNAVAILABLE;
 */

- (void)testMsgSendAction {
    
    SKRuntimePerson *p  =  [[SKRuntimePerson alloc]init];
    [p performSelector:@selector(foo)];
    [p foo];
// 面试题解答：
    // 方法调用如下： 其实就是在objc编译的时候，会被转义为： objc_msgSend(p,@selectpr(foo));
    /*
     ((id (*)(id, SEL, SEL))(void *)objc_msgSend)((id)p, sel_registerName("performSelector:"), sel_registerName("foo"));
     ((void (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("foo"));
     */
}

- (void)foo {
    NSLog(@"执行方法foo");
}

// 面试题解答：runtime如何通过selector找到对应的IMP地址(分别考虑类方法和实例方法)
/*
  通过clang分析我们可以知道 每个类对象都有一个方法列表，方法列表中记录着方法的名称，方法实现，以及参数类型。其实selector本质就是方法名称，
  通过这个方法名称就可以在方法列表中找到对应的方法实现。
 */
// 面试题解答：_objc_msgForward函数是做什么的，直接调用它将会发生什么？
/*
 _objc_msgForward 是IMP类型的。，主要用于消息转发。当向一个对象发送一条消息，但它没有实现的时候，_objc_msgForward会尝试做消息转发。
我们可以这样创建一个_objc_msgForward对象：     IMP msgForwardIMP = _objc_msgForward;
  在objc向对象发送一个消息和objc_msgSend函数之间有什么关系的时候，起到了消息传递的作用。在消息传递过程中，objc_msgSend 的动作比较清晰：首先在Class的缓存中查找IMP(没缓存就初始化缓存)，如果没有去父类进行查找。如果查找到NSObject类仍然没有实现，则用_objc_msgForward函数指针替代IMP,最后执行这个IMP.
 
 对于_objc_msgForward这里有关三个函数使用伪代码来表示：--具体可以看 runtime源码
  id  objc_msgSend(id self, SEL op, ...) {
      if(!self) return nil;
      IMP imp = class_getMethodImplementation(self->isa, SEL op);
      imp(self,op, ...);// 调用这两段代码
  }
 // 查找IMP 实现
   IMP class_getMethodImplementation(Class cls, SEL sel) {
    IMP imp;
    if (!cls  ||  !sel) return nil;
    imp = lookUpImpOrNil(cls, sel, nil,YES, YES, YES);
    // Translate forwarding function to C-callable external version
    if (!imp) {
        return _objc_msgForward;
    }
    return imp;
}
 // 查看实现是否为空(源码是这样的)
 IMP lookUpImpOrNil(Class cls, SEL sel, id inst,
                    bool initialize, bool cache, bool resolver)
 {
     IMP imp = lookUpImpOrForward(cls, sel, inst, initialize, cache, resolver);
     if (imp == _objc_msgForward_impcache) return nil;
     else return imp;
 }
 //  这一步可以总结为:
 IMP lookUpImpOrNil(Class cls, SEL sel) {
     if (!cls->initialize()) {
         _class_initialize(cls);
     }
  
     Class curClass = cls;
     IMP imp = nil;
     do { //先查缓存,缓存没有时重建,仍旧没有则向父类查询
         if (!curClass) break;
         if (!curClass->cache) fill_cache(cls, curClass);
         imp = cache_getImp(curClass, sel);
         if (imp) break;
     } while (curClass = curClass->superclass);
  
     return imp;
 }
  
 // _objc_msgFowrard 在进行消息转发的过程中会涉及一下这几个方法
   1. resolveInstanceMethod: 方法(resolveClassMethod)
   2. forwardingTargetForSelector:
   3. methodSignatureForSelector
   4. forwardInvocation:
   5. doesNotRecognizeSelector:

 
  直接调用_objc_msgFoward 是非常危险的事。如果用不好会导致程序crash，直接调用的话 会跳过消息发送(objc_msgSend)，直接进入消息转发(_objc_msgFoward)阶段
 有哪些场景需要用到_objc_msgFoward 最常见的是你想获取方法对应的NSInvocation对象的时候。例如：jspatch和rac

 */

// 延伸资料：
// 1.iOS中的SEL和IMP到底是什么?  https://blog.csdn.net/dkq972958298/article/details/69942077
// 2.
@end
