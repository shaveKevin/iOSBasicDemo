//
//  SKConstructArr.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/4/13.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKConstructArr.h"

@implementation SKConstructArr

int* constructArr(int* a, int aSize, int* returnSize) {
    int *arr = NULL;
    int i ,temp;
    if (a== NULL || aSize <= 0) {
        return  NULL;
    }
    int *resultArray =  malloc(*returnSize);
    for (int i = 0; i<aSize; i ++) {
        int result = 1;
        for (int j = 0; j < aSize; j ++) {
            if (i == j) {
                continue;
            } else {
                result *= a[j];
            }
        }
        resultArray[i] = result;
    }
    return resultArray;
}

@end
