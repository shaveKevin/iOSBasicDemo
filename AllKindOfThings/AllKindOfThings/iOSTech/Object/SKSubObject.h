//
//  SKSubObject.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKObjectObject.h"

NS_ASSUME_NONNULL_BEGIN
// 面试题： 一个objc对象如何进行内存布局？（考虑有父类的情况）？
// 一个objc对象的isa指针指向什么，有什么作用？
// 面试题：下面的代码输出什么？
/*
  - (instancetype)init {
      
      if (self = [super init]) {
          NSLog(@"[self class] == %@   %p",NSStringFromClass([self class]),[self class]);
          NSLog(@"[super class] == %@   %p",NSStringFromClass([super class]),[super class]);
      }
      return self;
  }
 */
@interface SKSubObject : SKObjectObject

@property (nonatomic, strong) NSString *subObjectString;

- (void)printSubObject;

+ (void)thisisSubMethod;

@end

NS_ASSUME_NONNULL_END
