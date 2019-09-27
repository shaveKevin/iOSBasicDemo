//
//  SKSubObject.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKObjectObject.h"

NS_ASSUME_NONNULL_BEGIN
// 面试题： 一个objc对象如何进行内存布局？（考虑有父类的情况）
@interface SKSubObject : SKObjectObject

@property (nonatomic, strong) NSString *subObjectString;

- (void)printSubObject;

+ (void)thisisSubMethod;

@end

NS_ASSUME_NONNULL_END
