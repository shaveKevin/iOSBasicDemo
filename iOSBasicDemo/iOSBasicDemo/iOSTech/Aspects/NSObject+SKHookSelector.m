//
//  NSObject+SKHookSelector.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/30.
//  Copyright © 2019 小风. All rights reserved.
//

#import "NSObject+SKHookSelector.h"
#import <objc/runtime.h>

#import "Aspects.h"


@implementation NSObject (SKHookSelector)

+ (void)load {
    swizzleMethod([self class], @selector(doesNotRecognizeSelector:), @selector(swizzled_doesNotRecognizeSelector:));

}

- (void)swizzled_doesNotRecognizeSelector:(SEL)aSelector {
    
    @try {
        [self swizzled_doesNotRecognizeSelector:aSelector];
        
    } @catch (NSException *exception) {
        //捕获异常，根据exception打印出堆栈信息，同时也避免了程序崩溃
        //上报
        NSLog(@"异常信息%@",exception);
        
    } @finally {
        
    }
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

+ (void)hookSelector {
   
    [self aspect_hookSelector:@selector(doesNotRecognizeSelector:)
                  withOptions:AspectPositionBefore
                   usingBlock:^(id<AspectInfo> aspectInfo, SEL selector) {
        NSObject * obj = aspectInfo.instance;
        NSLog(@"obj is ===%@",obj);
    } error:NULL];
}

@end
