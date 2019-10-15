//
//  SKProprtyModel.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
// 解答面试题：@synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？
// 面试题： 在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？
NS_ASSUME_NONNULL_BEGIN

@interface SKProprtyModel : NSObject

@property (nonatomic, copy) NSString  *timeStamps;

@property (nonatomic, copy) NSString  *upAndDown;

@property (nonatomic, copy) NSString  *foo;

@property (nonatomic, copy) NSString  *animal;

@property (nonatomic, copy) NSString  *mouse;

@end

NS_ASSUME_NONNULL_END

// 对应目录下执行：xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc SKProprtyModel.m -o SKProprtyModel-arm64.cpp  就可以生成cpp文件
