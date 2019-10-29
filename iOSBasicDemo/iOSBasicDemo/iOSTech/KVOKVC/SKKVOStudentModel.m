//
//  SKKVOStudentModel.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/28.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKKVOStudentModel.h"

@implementation SKKVOStudentModel

@synthesize stdName = _stdName;

- (void)setStdName:(NSString *)stdName {
    _stdName = stdName;
}
- (NSString *)stdName {
    return _stdName;
}

- (void)setStdAge:(NSString *)stdAge {
    [self willChangeValueForKey:@"stdAge"];
    _stdAge = stdAge;
    [self didChangeValueForKey:@"stdAge"];
}

- (NSString *)stdAge {
    return _stdAge;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
// 如果监测的key是stdAge的时候，不用系统的检测方式 自己来实现。
    if ([key isEqualToString:@"stdAge"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}
@end
