//
//  SKRuntimePerson.m
//  AllKindOfThings
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
 // http://weibo.com/luohanchenyilong/
 // https://github.com/ChenYilong
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


@end
