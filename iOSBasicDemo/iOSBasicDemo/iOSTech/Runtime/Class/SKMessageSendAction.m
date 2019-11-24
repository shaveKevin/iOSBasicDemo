//
//  SKMessageSendAction.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKMessageSendAction.h"
#import <objc/runtime.h>
#import "SKRuntimeOtherObject.h"

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
 2. 如果没有在resolveInstanceMethod里面写处理逻辑，那么就到了第二次机会挽救app crash了。这个里面没有创建新的对象。只是把当前对象的方法转嫁给其他类的方法而已(这个方法返回的是一个对象)
 3. 如果前两步都没有处理那么第三步 会在这里返回一个方法的标识NSMethodSignature，然后重新进入消息转发 会走第一步晚挽回闪退的方法，然后执行forwardInvocation方法，根据目标对象的方法标识找到转发的方法 通过runtime生成NSInvocation对象 执行invokeWithTarget 执行方法
 4. 如果1 2  3  都不满足。那么就只能走doesNotRecognizeSelector方法了然后就crash了
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
// 打印结果：1.挽救闪退 step  one add method 保证不crash
//         我是挽救闪退添加的方法保证不crash
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"1.挽救闪退 step  one add method 保证不crash");
    // 注意这里有方法缓存。 第一次调用之后。再次调用直接走方法 这里就不走了。
    // 打开注释即可测试第二步
    return YES;
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
    NSLog(@"我是挽救闪退添加的方法保证不crash");
}

//- (void)testUnrecognizedSelector {
//    NSLog(@"实现了方法");
//}
// 如果resolveInstanceMethod 或者 resolveClassMethod 未做处理 这里是补救措施的第二步
// 如果当前类处理不了 就转交给其他类来处理，同时将消息转发给其他类的对象来处理、 这一步runtime没有创建新的对象
// 打印结果:1.挽救闪退 step  one add method 保证不crash
//        2.挽救闪退 step two  :forwardingTargetForSelector
- (id)forwardingTargetForSelector:(SEL)aSelector {
    // 这里没有缓存。每调用一次就会走一次方法
    NSLog(@"2.挽救闪退 step two  :forwardingTargetForSelector");
    // 打开注释即可测试第三步
    return  [super forwardingTargetForSelector:aSelector];
    
    if (aSelector == @selector(testUnrecognizedSelector)) {
        SKRuntimeOtherObject  *obj  = [[SKRuntimeOtherObject alloc]init];
        return obj;
    }
    return  [super forwardingTargetForSelector:aSelector];
}

//通过打印可以看出 走到第三步的时候，根据NSMethodSignature
// 找到对应的标识 然后继续执行消息转发走到第一步，接着走forwardInvocation 创建一个NSInvocation对象，然后直接调用方法invokeWithTarget
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    
//    return [super methodSignatureForSelector:aSelector];

    NSLog(@"3.1挽救闪退 step three  :methodSignatureForSelector");
    // 当再次调用的时候resolveInstanceMethod 只会走一次。剩下的方法都会走。
    SKRuntimeOtherObject  *obj  = [[SKRuntimeOtherObject alloc]init];
    if (aSelector == @selector(testUnrecognizedSelector)) {
        // 这个标识代表的是：
        //只要参数相同以及是否有返回值(不管返回值类型是否相同)都相同的话，返回的标识就是相同。。也就是说 这个标识代表的是是否一类方法。
        NSMethodSignature *methodSignature = [obj methodSignatureForSelector:@selector(stepThreeUnrecognizedSelector:)];
        return methodSignature;
    }
    return [super methodSignatureForSelector:aSelector];
}
// 这里实例是将方法转发给其他类
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [super forwardInvocation:anInvocation];
//    return;
    NSLog(@"3.2挽救闪退 step three & step two :forwardInvocation");
    SEL sel = [anInvocation selector];
    SKRuntimeOtherObject  *obj  = [[SKRuntimeOtherObject alloc]init];
    if ([obj respondsToSelector:sel]) {
        // 转发到那个方法
        [anInvocation setSelector:@selector(stepThreeUnrecognizedSelector:)];
        NSString *args = @"==this is parame";
        // 为啥从2开始呢。因为一个是self 和 _cmd
        // 添加参数
        [anInvocation setArgument:&args atIndex:2];
        [anInvocation invokeWithTarget:obj];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

// 打印结果为：
/*
 1.挽救闪退 step  one add method 保证不crash
 2.挽救闪退 step two  :forwardingTargetForSelector
 3.1挽救闪退 step three  :methodSignatureForSelector
 1.挽救闪退 step  one add method 保证不crash
 3.2挽救闪退 step three & step two :forwardInvocation
 */
// 重写系统的方法doesNotRecognizeSelector:
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
    NSLog(@"方法名是：%@",NSStringFromSelector(aSelector));
    NSLog(@"走到这里说明：补救措施都没有 等着挂了吧 == 看来是后娘养的");
    [super doesNotRecognizeSelector:aSelector];
}

// 关于NSMethodSignature  可参考 ： https://www.jianshu.com/p/70a8b3f62107

// 关于OC的消息发送和转发原理 可参考： https://xiaozhuanlan.com/topic/9417083256
// 延伸提问： NSInvocation invokeWithTarget  和performSelector：withObject：有什么区别？
// 答:performSelector：withObject：这种类型的方法最多有两个参数
// NSInvocation 可以设置多个参数。
// 使用方式不同：通过NSObject类生成方法签名。通过方法签名生成invocation。设置方法的调用者以及选择器和参数。如果有返回值 获取返回值
// performSelector：withObject： 直接调用即可 - (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2
// 具体实例 见SKRuntimeVC



@end
