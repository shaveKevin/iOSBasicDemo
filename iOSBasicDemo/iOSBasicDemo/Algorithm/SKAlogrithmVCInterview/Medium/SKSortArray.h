//
//  SKSortArray.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/31.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 912. 排序数组
 给你一个整数数组 nums，请你将该数组升序排列。

  

 示例 1：

 输入：nums = [5,2,3,1]
 输出：[1,2,3,5]
 示例 2：

 输入：nums = [5,1,1,2,0,0]
 输出：[0,0,1,1,2,5]
  

 提示：

 1 <= nums.length <= 50000
 -50000 <= nums[i] <= 50000
 链接：https://leetcode-cn.com/problems/sort-an-array/
 */
NS_ASSUME_NONNULL_BEGIN

@interface SKSortArray : NSObject

int* sortArray(int* nums, int numsSize, int* returnSize);
@end

NS_ASSUME_NONNULL_END
