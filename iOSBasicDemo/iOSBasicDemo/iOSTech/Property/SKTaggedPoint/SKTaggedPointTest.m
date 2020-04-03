//
//  SKTraggedPointTest.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTaggedPointTest.h"


@interface SKTaggedPointTest ()

@property (nonatomic, copy) NSString *nameStr;

@end
@implementation SKTaggedPointTest

+ (void)load {
    NSLog(@"当前类的load");
}

+ (void)initialize {
    NSLog(@"当前类的initialize");
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSNumber *number1 = @(0);
        NSNumber *bigNumber = @(999999999999999);
        NSString *string = @"5";
        NSString *longString = [[string mutableCopy]copy];
        NSMutableString *mutableString = [NSMutableString stringWithString:string];
        NSLog(@"number1 class is %@",[number1 class]);
        NSLog(@"bigNumber class is  %@",[bigNumber class]);
        NSLog(@"string class is  %@",[string class]);
        NSLog(@"longString class is  %@",[longString class]);
    }
    return self;
}

/*
 方法的执行顺序
 当前类的load
 子类的load
 (分类和子类分类的+load方法的执行顺序依赖于他们的编译顺序)
 分类的load
 子类分类的load
 
 
initialize 执行顺序
 app运行过程中只会触发一次，如果分类和当前类同时存在那么分类会覆盖掉本类的initialize方法调用。优先级是 分类优先于分类子类执行。如果分类较多只会执行一个，最后一个被添加进去的分类会覆盖掉原先分类的initialize方法
 分类的initialize
 子类分类的initialize
 
 */

// 判断是否是taggpointer  查看最低有效位 如果为1 就是taggedpointer 否则就不是

BOOL  isTaggedPoint(id pointer) {
    return (long)(__bridge void*)pointer  & 1;
}

/*
 源码中是这样判断的
 
 #if OBJC_MSB_TAGGED_POINTERS
 #   define _OBJC_TAG_MASK (1UL<<63)
 #else
 #   define _OBJC_TAG_MASK 1UL
 #endif
 static inline bool
 _objc_isTaggedPointer(const void * _Nullable ptr)
 {
     return ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
 }
 */

- (void)taggedPointedMethod01 {
    // 运行会crash 因为这个时候是对象
    // @"*** -[%s %s]: message sent to deallocated instance %p"
    // 对象在赋值的时候会调用setName:方法 底层调用的时候会 先释放旧值 然后赋新值。 如果多个线程都访问这个对象的时候，可能多个线程会调用[_nameStr release];方法 这样就会重复释放，会crash。解决方案可以在赋值前后加锁。不建议把属性设置为atomic 因为这个加锁会很耗性能。 这个指针叫悬垂指针 悬垂指针指的是被释放掉对象的指针。野指针指的是没有初始化的指针。
    /*
     - (void)setNameStr:(NSString *)nameStr {
         if (_nameStr!=nameStr) {
             [_nameStr release];
             _nameStr  = [nameStr retain];
         }
     }
     */
    dispatch_queue_t queue = dispatch_queue_create("com.shavekevin", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000; i ++) {
        dispatch_async(queue, ^{
            self.nameStr = [NSString stringWithFormat:@"com.shavekevin"];
        });
    }
    
}

- (void)taggedPointedMethod02 {
    // 运行不会crash  因为这个时候self.nameStr 是taggpointer   taggpointer 赋值以后是指针的赋值
    dispatch_queue_t queue = dispatch_queue_create("com.shavekevin", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1000; i ++) {
        dispatch_async(queue, ^{
            self.nameStr = [NSString stringWithFormat:@"123"];
        });
    }
}

@end

// 面试题答案：谈谈你对伪指针Tagged Pointer的理解。
/*  如果存储值大小超过8个字节，那么使用和64bit之前一样。存储空间变为堆。
 答:用指针存储值。节省内存空间。从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储。
  在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值。
  使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中。
  当指针不够存储数据时，才会使用动态分配内存的方式来存储数据。
 objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销。
 iOS平台，最高有效位是1（第64bit）Mac平台，最低有效位是1
 */
// 面试题：如何判断一个指针是否为Tagged Pointer？
/*
 答：当指针的最高有效位是1的时候，是Tagged Pointer。如果是16的倍数，那么不是。 可以使用& 运算符来判断
 */

/*
 NSString *namestr = [NSString stringWithFormat:@"com.shavekevin.com"];
    
    NSLog(@"==namestr====%p",namestr);
    namestr = @"abc";
    NSLog(@"===namestr====%p",namestr);
 打印结果为：   0x6000009d0030
              0x10145e4e0
 
 这说明初始化的时候oc对象，再次赋值的时候是taggedpointer 这样节省空间。
 */
