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
 分析：这道题有以下解法：(暴力法)1.可以通过嵌套循环遍历来解决，外层遍历拿到所有的数字，内层遍历拿到剩下的数字，判断如果外层拿到的数字和内层遍历中拿到的数字相同，那么结束本次遍历(题意元素最多出现两次)，直到找到出现一次的数字为止(在这里可以用一个变量来表示外层遍历数字出现的次数，遍历完对应内层的时候如果这个变量为1。那么结束循环，否则继续)
 (异或)2.可以用异或运算符，异或运算符的作用和是相同为1 不同为0。异或有这样一种性质：(a^b)^b=a;这正好符合我们的题意。我们可以利用这个性质来抵消两个相同的数字，最后得到的数字就是我们所要找到的出现一次的数字。这个解法也就是说当两个相同的数字进行异或的时候相当于抵消的操作。
 */
@end

NS_ASSUME_NONNULL_END
