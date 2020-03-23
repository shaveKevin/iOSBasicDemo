//
//  SKRotateArray.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/21.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKRotateArray.h"

@implementation SKRotateArray
/*
 输入: [1,2,3,4,5,6,7] 和 k = 3
 输出: [5,6,7,1,2,3,4]
 解释:
 向右旋转 1 步: [7,1,2,3,4,5,6]
 向右旋转 2 步: [6,7,1,2,3,4,5]
 向右旋转 3 步: [5,6,7,1,2,3,4]
 */
// 暴力法是每次只移动一个元素
void rotateArray(int* nums, int numsSize, int k){
    int temp,previous;
    for (int  i = 0; i < k; i ++) {
        // 拿到最后一个元素
        previous = nums[numsSize-1];
        // 依次进行交换  每个元素都和最后一位进行交换
        for (int j = 0; j < numsSize; j++) {
            temp = nums[j];
            nums[j] = previous;
            previous = temp;
        }
    }
}
// 使用额外数组  这个就是我们要把我们需要改变的 把原来数组里下标为i的放到(i+k）% 数组长度的位置  用的就是取余。
void rotateArrayTwo(int* nums, int numsSize, int k){
    int array[numsSize];
    for (int i = 0; i < numsSize; i ++) {
        array[(i + k)%numsSize] = nums[i];
    }
    for (int i = 0; i < numsSize; i ++) {
        nums[i]=  array[i];
    }
}
// 可以使用反转数组来处理 首先反转整个数组，然后反转numberSize-k个元素
void rotateArrayThree(int* nums, int numsSize, int k) {
    k %= numsSize;
    // 反转所有数字
    reverse(nums, 0, numsSize-1);
    // 反转前k个数字
    reverse(nums, 0, k-1);
    // 反转后numsSize-k个数字
    reverse(nums, k, numsSize-1);
    
}
// 反转
void reverse(int *array, int  start, int end) {
    while (start < end) {
        int temp = array[start];
        array[start]=array[end];
        array[end] = temp;
        start++;
        end--;
    }
}

@end
