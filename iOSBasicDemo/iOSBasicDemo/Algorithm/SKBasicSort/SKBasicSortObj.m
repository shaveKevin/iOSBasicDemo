//
//  SKBasicSortObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/16.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKBasicSortObj.h"

@implementation SKBasicSortObj

/**
冒泡排序
时间复杂度：O(n^2)
*/
void bubbldSort (int array[],int length) {
    int  temp = 0;
    for (int i = 0; i < length; i ++) {
        for (int j = 0; j < length -1; j++) {
            if (array[i]< array[j]) {
                temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
    }
}

@end
/*
最快最简单的排序： 桶排序。
 */
