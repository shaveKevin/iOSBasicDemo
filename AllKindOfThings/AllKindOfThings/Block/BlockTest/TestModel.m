
//
//  TestModel.m
//  TestBlock
//
//  Created by shavekevin on 2019/8/12.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "TestModel.h"

@interface TestModel()


@end

@implementation TestModel {
    NSMutableSet *_models;
}

// 遵循NSCoping协议
- (id)copyWithZone:(NSZone *)zone {
    TestModel *model = [[[self class] allocWithZone:zone] initWithName:_name age:_age];
    model->_models = [_models mutableCopy];
    return model;
    
}

- (instancetype)initWithName:(NSString *)name age:(int)age {
    if (self = [super init]) {
        _name = [name copy];
        _age = age;
        _models = [[NSMutableSet alloc]init];
    }
    return self;
}

- (void)addModel:(TestModel *)model {
    [_models addObject:model];
}

- (void)removeModel:(TestModel *)model {
    [_models removeObject:model];
}

- (id)deepCopy {
    
    TestModel *model = [[[self class] alloc] initWithName:_name age:_age];
    model->_models = [[NSMutableSet alloc]initWithSet:_models copyItems:YES];
    return model;
}
@end
