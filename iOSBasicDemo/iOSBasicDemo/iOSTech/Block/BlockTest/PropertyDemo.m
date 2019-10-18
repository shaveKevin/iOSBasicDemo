//
//  PropertyDemo.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/13.
//  Copyright © 2019 小风. All rights reserved.
//

#import "PropertyDemo.h"


@interface PropertyDemo ()

@property (nonatomic, copy) NSString *firstName;

@end

@implementation PropertyDemo


@end
// 关于声明@property之后 生成了的  可以看出 这是一个结构体
/*
 extern "C" unsigned long OBJC_IVAR_$_PropertyDemo$_firstName;
 struct PropertyDemo_IMPL {
 struct NSObject_IMPL NSObject_IVARS;
 NSString *_firstName;
 };

 */
