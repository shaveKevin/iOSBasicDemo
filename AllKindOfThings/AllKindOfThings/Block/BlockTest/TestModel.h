//
//  TestModel.h
//  TestBlock
//
//  Created by shavekevin on 2019/8/12.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestModel : NSObject<NSCopying>


@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) int age;

- (instancetype)initWithName:(NSString *)name age:(int)age;

- (void)addModel:(TestModel *)model;

- (void)removeModel:(TestModel *)model;


@end

NS_ASSUME_NONNULL_END
