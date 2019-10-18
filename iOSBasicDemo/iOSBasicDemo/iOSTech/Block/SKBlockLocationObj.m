//
//  SKBlockLocationObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKBlockLocationObj.h"

@implementation SKBlockLocationObj

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)blockLocation {
    __block int a = 10;
    NSLog(@"定义前a的地址为： %p a的值为%@",&a,@(a));
    void(^foo)(void) = ^ {
        a = 15;
        NSLog(@"block中a的地址为： %p a的值为%@",&a,@(a));
    };
    NSLog(@"定义后a的地址为： %p  a的值为%@",&a,@(a));
    foo();
    NSLog(@"调用后a的地址为： %p a的值为%@",&a,@(a));
}

@end
