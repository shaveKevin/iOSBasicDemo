//
//  NSObject+SKRuntimeAssociatedObject.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "NSObject+SKRuntimeAssociatedObject.h"
#import <objc/runtime.h>

@implementation NSObject (SKRuntimeAssociatedObject)

- (void)setTimeValue:(NSString *)timeValue {
    objc_setAssociatedObject(self, @"timeValue", timeValue, OBJC_ASSOCIATION_COPY);
    
}

- (NSString *)timeValue {
    return  objc_getAssociatedObject(self, @"timeValue");
}
@end
