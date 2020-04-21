//
//  SKConstructArr.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/4/13.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 面试题66. 构建乘积数组
 给定一个数组 A[0,1,…,n-1]，请构建一个数组 B[0,1,…,n-1]，其中 B 中的元素 B[i]=A[0]×A[1]×…×A[i-1]×A[i+1]×…×A[n-1]。不能使用除法。

  

 示例:

 输入: [1,2,3,4,5]
 输出: [120,60,40,30,24]
  

 提示：

 所有元素乘积之和不会溢出 32 位整数
 a.length <= 100000
 链接：https://leetcode-cn.com/problems/gou-jian-cheng-ji-shu-zu-lcof/
 */
@interface SKConstructArr : NSObject

int* constructArr(int* a, int aSize, int* returnSize);

@end

NS_ASSUME_NONNULL_END
