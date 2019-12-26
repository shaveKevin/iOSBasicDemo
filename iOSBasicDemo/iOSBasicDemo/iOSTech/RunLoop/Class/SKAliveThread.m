//
//  SKAliveThread.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKAliveThread.h"

@interface SKAliveThread ()

@property (nonatomic, strong) NSThread * currenThread;

@property (nonatomic, assign) BOOL  stopped;

@end

@implementation SKAliveThread

- (instancetype)init {
    
    if (self = [super init]) {
        self.stopped = NO;
        self.currenThread = [[NSThread alloc]initWithBlock:^{
            __weak typeof(self)weakSelf = self;
            [[NSRunLoop currentRunLoop]addPort:[NSPort port] forMode:NSRunLoopCommonModes];
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop]runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
            }
        }];
        
    }
    return self;
}
- (instancetype)initWithCLau {
    
    if (self = [super init]) {
        // 如果用c语言实现的话不需要用停止标志。
        self.currenThread = [[NSThread alloc]initWithBlock:^{
            __weak typeof(self)weakSelf = self;
            NSLog(@"启动");
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef ref = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // 向runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), ref, kCFRunLoopCommonModes);
            // 销毁 source
            CFRelease(ref);
            // 启动
            // 第三个参数设置为true的时候，说明执行完source后就会退出当前runloop
            CFRunLoopRunInMode(kCFRunLoopCommonModes, 1.0e10, true);
            NSLog(@"销毁");
        }];
    }
    return self;
}

- (void)run {
    if (!self.currenThread) return;
    [self.currenThread start];
}

- (void)executeTaskWithBlock:(ExuteBlock)task {
    
    if (!self.currenThread|| !task) return;
    [self performSelector:@selector(__excuteTask:) onThread:self.currenThread withObject:task waitUntilDone:YES];
}

- (void)stop {
    if (!self.currenThread) return;
    [self performSelector:@selector(__stop) onThread:self.currenThread withObject:nil waitUntilDone:YES];
}

- (void)__stop {
    self.stopped = YES;
    // 销毁
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 置空
    self.currenThread = nil;
}

- (void)__excuteTask:(ExuteBlock)task {
    task();
}
@end
