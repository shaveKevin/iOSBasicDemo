//
//  SKTraggedPointTest.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTraggedPointTest.h"


@interface SKTraggedPointTest ()

@end
@implementation SKTraggedPointTest

+(void)load {
    NSLog(@"当前类的load");
}

+(void)initialize {
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


@end
