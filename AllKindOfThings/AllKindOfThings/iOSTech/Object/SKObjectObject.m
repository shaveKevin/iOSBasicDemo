//
//  SKObjectObject.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKObjectObject.h"

@implementation SKObjectObject
// 打印结果是： <SKObjectObject: 0x282bb0000>
//打印结果是： SKObjectObject

- (void)printObjectObject {
    NSLog(@"canyoutellme who am i ");
    NSLog(@"self=== %p",self);
}

+ (void)thisisSuperMethod {
    NSLog(@"thisisSuperMethod");
    NSLog(@"self===%p",self);

}

// 面试题解答:
/*
  类方法：
   1.类方法是属于类对象的；
   2.类方法只能通过类对象调用；
   3.类方法中的self是类对象
   4.类方法可以调用其他的类的方法
   5.类方法不能访问成员变量
   6.类方法中不能直接调用对象的方法
 
   实例方法：
   1.实例方法属于实例对象的；
   2.实例方法只能通过实例对象调用
   3.实例方法中的self是实例对象
   4.实例方法中可以访问成员变量
   5.实例方法中可以直接调用实例方法
   6.实例方法中可以调用类方法(通过类名)
 
 */
- (id)printClass {
    NSLog(@"1.1 SKObjectObject ===%@",self);
    return self;
}
@end
