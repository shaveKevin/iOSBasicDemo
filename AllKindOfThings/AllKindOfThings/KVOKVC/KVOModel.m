//
//  KVOModel.m
//  KVO-Nature-Demo
//
//  Created by shavekevin on 2019/8/19.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "KVOModel.h"
@implementation KVOModel

- (void)setAge:(NSInteger)age {
    NSLog(@"age ============%@",@(age));
    _age = age;
}

@end
