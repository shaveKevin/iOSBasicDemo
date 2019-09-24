//
//  NSObject+Addition.m
//  TestBlock
//
//  Created by shavekevin on 2019/8/14.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "NSObject+Addition.h"
#import<objc/runtime.h>
static const char * MustBeCount = "MustBeCount";

@implementation NSObject (Addition)
// 使用runtime来给分类添加属性
- (void)setMustBeCount:(NSString *)mustBeCount {
    
    objc_setAssociatedObject(self, MustBeCount, mustBeCount, OBJC_ASSOCIATION_COPY);
}

- (NSString *)mustBeCount {
    
    return objc_getAssociatedObject(self, MustBeCount);
}


@end
