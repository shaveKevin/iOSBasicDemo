//
//  SKMessageSendAction.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKMessageSendAction.h"
#import <objc/runtime.h>

// 首先如果不实现的话，会crash,原因是找不到方法 此时会报警告：Method definition for 'testUnrecognizedSelector' not found
/*
  *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SKMessageSendAction testUnrecognizedSelector]: unrecognized selector sent to instance 0x2836ac510'
 */
// 面试解答：
/*
 简单来说，当调用对象某个方法，但是这个对象并没有实现这个方法的时候，可以通过消息转发来解决。
  objc在向一个对象发送消息的时候，runtime会根据对象的指针找到对喜感所属的类，然后在这个类的方法类表以及父类的方法列表中
  寻找方法，如果在最顶层的父类中仍然找不到方法的时候，程序就会挂掉并抛出异常unrecognized selector sent to instance。但是在这之前有三次机会来拯救 保持程序不crash
 1.resolveInstanceMethod  或者 resolveClassMethod
 2. 如果没有在resolveInstanceMethod里面写处理逻辑，那么
 */
@interface SKMessageSendAction ()

- (void)testUnrecognizedSelector;

@end

@implementation SKMessageSendAction

- (void)takeActions {
    [self testUnrecognizedSelector];
}
// 只要代码走到这里证明目标对象没有实现这个方法  这里可以做的操作是：
/*
  1. 为了保证不闪退，可以新增一个方法保证app正常运行。如果这里需要处理逻辑问题并且会影响业务,建议还是让让闪退吧
 
  2. 添加埋点上报异常信息(这个在debug模式下可以不用上报)
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
// 这个判断可以不用写。因为既然走这里了，证明找不到方法，便于理解才这样写。
    if (![self respondsToSelector:sel]) {
        if (sel == @selector(testUnrecognizedSelector)) {
            class_addMethod([self class], sel, (IMP)testMethod, "this is new method");
            return YES;
        }
    }
    return [super resolveInstanceMethod:sel];
}

void testMethod (id  self, SEL  _cmd) {
    NSLog(@"add method 保证不crash");
}

- (void)testUnrecognizedSelector {
    NSLog(@"实现了方法");
}
@end
