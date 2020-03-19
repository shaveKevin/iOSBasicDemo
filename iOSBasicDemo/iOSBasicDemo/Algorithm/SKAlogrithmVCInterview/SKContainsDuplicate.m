//
//  SKContainsDuplicate.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/19.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKContainsDuplicate.h"

@implementation SKContainsDuplicate
//  暴力解法会超时 这里可以先把所有的数据进行排序然后在进行比较

bool containsForceDuplicate(int* nums, int numsSize) {
    bool duplicate = false;
    int i,j;
    for (i = 0; i < numsSize; i ++) {
        for (j = 0; j < numsSize; j++) {
            if (i == j) {
                continue;
            }
            if (nums[i] == nums[j]) {
                duplicate = true;
            }
        }
    }
    return duplicate;
}
// 先排序后判断
bool containsDuplicate(int* nums, int numsSize) {
        // 冒泡排序
        bubbleSort(nums, numsSize);
        for (int i = 0; i <numsSize-1; i ++) {
            if (nums[i] == nums[i+1]) {
                return true;
            }
        }
   
    return false;
}

void bubbleSort(int* dataArray, int arraySize) {
    for (int i = 0; i < arraySize; i ++) {
        int flag = 0;
        for (int j = 0; j < arraySize-1-i; j++) {
            if (dataArray[j] > dataArray[j+1]) {
                flag = 1;
                int temp = dataArray[j];
                dataArray[j] = dataArray[j+1];
                dataArray[j+1]= temp;
            }
        }
        if (flag == 0) {
            break;
        }
    }
}

//+ (void)load {
//
//    int array[6] = {1,2,3,4,5,2};
//  bool contain =  containsDuplicate(array, 6);
//
//    NSLog(@"%@",@(contain));
//}
@end
