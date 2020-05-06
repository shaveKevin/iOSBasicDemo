//
//  SKMoveZeroes.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/24.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKMoveZeroes.h"

@implementation SKMoveZeroes

void moveZeroes(int* nums, int numsSize) {
    if (!nums || numsSize == 0 ) {
        return;
    }
    // 双指针可以处理。  一个指针正常循环i，另外一个指针j发现一个不为0  那么就把这个指针赋值。 也就是说i 为快指针，j为慢指针。i循环结束的时候，刚好慢指针都有值，然后给数组在慢指针之后的值赋为0即可，当然用交换更好，这样的话就不用在循环给为0 的地方赋值了。
    int i,j = 0;
    for (i = 0 ; i < numsSize; i++) {
        if (nums[i] != 0) {
            // 用交换更好
            nums[j++] = nums[i];
        }
    }
    for ( int q = j;  q < numsSize; q ++) {
        nums[q] = 0;
    }
}

void moveZeroesSwap(int* nums, int numsSize) {
    if (!nums || numsSize == 0 ) {
        return;
    }
    int i,j = 0;
    for (i = 0 ; i < numsSize; i++) {
        if (nums[i] != 0) {
            int temp = nums[i];
            nums[i] =  nums[j];
            nums[j] = temp;
            j++;
        }
    }
}
@end
