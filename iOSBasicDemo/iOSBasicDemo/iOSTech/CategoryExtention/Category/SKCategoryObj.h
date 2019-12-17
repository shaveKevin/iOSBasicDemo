//
//  SKCategoryObj.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
// 面试题：如果分类中和原类都有同一个方法那么他们的执行顺序是什么样的？他们的顺序是否可以调整？如果可以，怎么调整呢？

NS_ASSUME_NONNULL_BEGIN

@interface SKCategoryObj : NSObject

- (void)testCategoryObjMethod;

@end

NS_ASSUME_NONNULL_END
