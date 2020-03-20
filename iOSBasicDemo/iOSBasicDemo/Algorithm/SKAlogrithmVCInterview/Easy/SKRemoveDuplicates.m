//
//  SKRemoveDuplicates.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/20.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKRemoveDuplicates.h"

@implementation SKRemoveDuplicates
// 分析:这道题的真正意图不是把重复的数字删除，返回的这个数字为不重复的所有数字的个数。。
// 这里参考了下官方的使用快慢指针来做,我们可以假设i 为慢指针  j 为快指针，当nums[i]和nums[j]相等的时候我们不做处理，让快指针继续向前移动。当nums[i]和nums[j]不相等的时候，这个时候  先让i进行++ 然后把数组中快指针对应的值给慢指针。nums[i]=nums[j]  比如原来的数组为[1,2,2,3] 则处理之后的数组为[1,2,3,3]而我们返回的数组个数为3。也就是说虽然这个数组已经有4个元素，我们使用的只是不重复的前三个
//  时间复杂度为O(n)，空间复杂度为O(1)
//
int removeDuplicates(int* nums, int numsSize){
    
    if (numsSize < 2) {
        return numsSize;
    }
    // 慢指针
    int i = 0;
    // 快指针
    int j = 1;
    for (j = 1; j < numsSize; j++) {
        // 如果发现不相等，那么就把数组中快指针对应的值给慢指针，如果相等的话 继续执行循环
        if (nums[j]!=nums[i]) {
            ++i;
            nums[i] = nums[j];
        }
    }
    return i+1;
}

@end
