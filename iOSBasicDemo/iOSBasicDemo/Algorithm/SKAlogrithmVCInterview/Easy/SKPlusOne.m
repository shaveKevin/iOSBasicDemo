//
//  SKPlusOne.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/24.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKPlusOne.h"

@implementation SKPlusOne

int* plusOne(int* digits, int digitsSize, int* returnSize) {
    for (int i = digitsSize-1; i >= 0; i --) {
        // 通过循环检查是是否大于9，如果不大于就赋值并返回
        if (digits[i] < 9) {
            digits[i]++;
            *returnSize = digitsSize;
            return digits;
        }
    // 如果检测到大于9  那么把该位置设置为0，继续循环
        digits[i] = 0;
    }
    //在上面的循环结束之后，如果没有返回说明要产生新的位了。这个时候的话 直接赋值就可以。
    int *array = (int *)malloc((digitsSize+1)*sizeof(int));
    array[0]= 1;
    for (int i = 1; i < digitsSize+1; i ++) {
        array[i] = 0;
    }
    *returnSize = digitsSize +1;
    return array;
}


@end
