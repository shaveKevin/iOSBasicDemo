//
//  SKKVCModel.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/30.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKKVCModel.h"

@implementation SKKVCModel
@synthesize name = _name;
// 如setvalue的属性没有实现那么这里可以做一下控制 用作容错。 当然，这里也可以用于处理映射的问题。如果映射的是关键字，那么这里可以更改映射的值
// 具体可参考yymodel实现
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
           _userId = value;
       }
}
- (id)valueForUndefinedKey:(NSString *)key {
   
    return nil;
}
- (void)setName:(NSString *)name {
    _name = name;
    NSLog(@"%@",@"setName");
}
- (NSString *)name {
    NSLog(@"%@",@"name");

    return _name;
}
@end
