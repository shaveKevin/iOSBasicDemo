//
//  SKRuntimeVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRuntimeVC.h"
#import "NSObject+SKRuntimeAssociatedObject.h"
#import "SKRuntimePerson.h"
#import "SKMessageSendAction.h"

@interface SKRuntimeVC ()

@end

@implementation SKRuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    // 对类添加属性
    [self runtimeProperty];
    // 发送空消息给一个对象会怎么样
    [self methodSendNil];
    // 消息转发机制
    [self messageSendUnrecognizedSelector];
    // 通过invocation和performselector执行方法的区别
    [self invocationAndPerformSelector];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)setupData {
    
}

- (void)setupLayout {
    
}


- (void)runtimeProperty {
    // 对类添加属性 采用的是runtime
    NSObject *objc = [[NSObject alloc] init];
    objc.timeValue = @"这是时间诶";
    NSLog(@"%@",objc.timeValue);
    
}

- (void)methodSendNil{
    SKRuntimePerson *person = [[SKRuntimePerson alloc]init];
    [person takeAction];
    [person testMsgSendAction];
}

- (void)messageSendUnrecognizedSelector {
    SKMessageSendAction *msgSend = [[SKMessageSendAction alloc]init];
    [msgSend takeActions];
}

- (void)invocationAndPerformSelector {
    
    // 1. NSInvocation
    // 第一步生成方法签名
    NSMethodSignature *methodSignature = [[self class] instanceMethodSignatureForSelector:@selector(invocationArgs:args2:args3:)];
    // 第二步由方法签名生成NSInvocation
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    // 第三步设置方法调用者
    invocation.target = self;
    // 第四步设置方法
    invocation.selector = @selector(invocationArgs:args2:args3:);
    // 第五步设置参数 注意参数
    NSString *args1 = @"第一个参数";
    NSString *args2 = @"第二个参数";
    NSString *args3 = @"第三个参数";
// 为啥设置参数要从第三个开始呢 因为第一个和第二个被self 和 _cmd 占用了
    [invocation setArgument:&args1 atIndex:2];
    [invocation setArgument:&args2 atIndex:3];
    [invocation setArgument:&args3 atIndex:4];
    // 第六步执行
    [invocation invoke];
// 第七步判断有无返回值 返回为signLength 为8
//    const char *sign = methodSignature.methodReturnType;
    NSUInteger signLength = methodSignature.methodReturnLength;
    // 返回值大于0 的时候
    if (signLength!=0) {
        // 有返回值
        NSLog(@"有返回值");
    } else{
        NSLog(@"没有返回值");
    }
    // 2. PerformSelector:object(最多支持两个参数) 通过id很容易就判断出 返回值类型 注意这里返回只能是个对象。。基本数据类型不行。。。
    
   id perfromSele  = [self performSelector:@selector(performSelectorS:arg2:) withObject:@"第一个参数" withObject:@"第二个参数"];
    if (perfromSele) {
        NSLog(@"打印结果为===%@",perfromSele);
    } else {
        NSLog(@"没有返回值");
    }
       // 这题意原本就是错误的。没有返回值 瞎接收什么
    id returnValue = [self performSelector:@selector(testReturnValueMethod)];
    // 闪退的时候 在这里 ->  0x107a85c9f <+591>: movq   %rax, -0x50(%rbp)
    // 0x107a85c9f 指令在内存中的地址， <+591  和上一个指令的；偏移地址差>将寄存器rax的值 (源操作数)写入rbp寄存器(目标操作数)
    if (returnValue) {
        NSLog(@"returnValue===%@",returnValue);
    } else {
        NSLog(@"returnValue ==没有返回值");
    }
    // 如果app闪退 可以通过LLDB的bt命令打印错误堆栈 （bt是thread backtrace的缩写） thread return 命令行终端某个方法可以返回想要的值
}

- (void)testReturnValueMethod {
  // 这里添加方法的时候会闪退。只要执行方法就闪退。 (汇编问题)原因应该是performSelector的returnvalue为x0， 当执行方法里面为空的时候，没有改变寄存器的地址。所以x0在PerformSelector的时候地址还为x0.如果方法里面调用堆栈的时候，最后导致x0不能被access所以就报bad access错误了。
    NSLog(@"this is method");
}

- (void )performSelectorS:(NSString *)args1 arg2:(NSString *)args2 {
    NSLog(@"performSelectorS args1 %@   args2 %@",args1,args2);
}

- (NSString *)invocationArgs:(NSString *)args1 args2:(NSString *)args2 args3:(NSString *)args3 {
    NSLog(@"args1 %@  args2 %@  args3 %@",args1,args2,args3);
    return @"xxx";
}

@end
