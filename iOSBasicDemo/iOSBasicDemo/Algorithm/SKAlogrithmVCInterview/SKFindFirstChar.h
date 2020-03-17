//
//  SKFindFirstChar.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKFindFirstChar : NSObject
// 查找第一次出现的只出现一次的字符
char findFirstChar(char *cha);

int firstUniqChar(char * s);


// 题目：查找只出现一次的数字
int singleNumber(int* nums, int numsSize);

/*
 给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。
 说明：

 你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

 示例 1:

 输入: [2,2,1]
 输出: 1
 示例 2:

 输入: [4,1,2,1,2]
 输出: 4
 链接：https://leetcode-cn.com/problems/single-number
 */
@end

NS_ASSUME_NONNULL_END
