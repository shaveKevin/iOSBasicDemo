//
//  KVOModel.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "KVOModel.h"

@interface KVOModel ()


@end
@implementation KVOModel

- (void)setAge:(NSInteger)age {
    NSLog(@"age ============%@",@(age));
    _age = age;
}

@end
