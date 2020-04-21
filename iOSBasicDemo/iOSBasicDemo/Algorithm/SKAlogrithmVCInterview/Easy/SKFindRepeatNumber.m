//
//  SKFindRepeatNumber.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/4/13.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKFindRepeatNumber.h"

@implementation SKFindRepeatNumber

int findRepeatNumber(int* nums, int numsSize){
    
    if (nums == NULL || numsSize <= 0) {
        return -1;
    }
    int colocNums[numsSize];
    // 先给额外的数组赋值
    for (int i = 0; i < numsSize; i ++) {
        colocNums[i] = 0;
    }
    //遍历拿到原数组值以后对，额外数组对应的数组进行赋值，找到一个就+1
    for (int i = 0 ; i < numsSize; i ++) {
            colocNums[nums[i]]++;

    }
    for (int i = 0; i < numsSize; i ++) {
        if (colocNums[i] >= 2) {
            return i;
        }
    }
    return -1;;
}

@end
