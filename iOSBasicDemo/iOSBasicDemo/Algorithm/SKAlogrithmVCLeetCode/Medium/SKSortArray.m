//
//  SKSortArray.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/31.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKSortArray.h"

@implementation SKSortArray
// 分析：这道题考察的是排序问题 可以使用快排来处理
int* sortArray(int* nums, int numsSize, int* returnSize) {
    *returnSize = numsSize;
    quickSortArray(nums, 0, numsSize-1);
    return nums;
}


void quickSortArray(int* nums, int  left , int right) {
    if (left > right) {
        return;
    }
    int j = partition(nums, left, right);
    quickSortArray(nums, left, j -1);
    quickSortArray(nums, j+1, right);
}

int partition (int *nums, int left,int right) {
    int i = left,j = right,temp = nums[left];
    while (i < j) {
        while (i <j && nums[j] > temp) {
            j --;
        }
        if (i < j) {
            nums[i] = nums[j];
            i ++;
        }
        while (i <j && nums[i] < temp) {
            i ++;
        }
        if (i < j) {
            nums[j] = nums[i];
            j--;
        }
    }
    nums[i] = temp;
    return i;
}

@end
