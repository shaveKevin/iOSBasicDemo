//
//  SKFindMiddleCount.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKFindMiddleCount.h"

@implementation SKFindMiddleCount
int  findMiddleCount(int list[], int aLen) {
    int low = 0;
    int high = aLen - 1;
    // 中位点
    int mid = (aLen - 1)/2;
    int div = PartSort(list, low, high);
    while (div != mid) {
        if (mid < div) {
            // 在左半区域查找
            div = PartSort(list, low, div -1);
        } else {
            // 在右半区域查找
            div = PartSort(list, div +1, high);
        }
    }
    // 找到的话 就返回
    return list[mid];
}
int PartSort( int a[], int start , int end) {
    int low = start;
    int high = end;
    // 选取关键字
    int key = a[end];
    while (low < high) {
        // 左边查找比key大的值
        while (low < high && a[low] <= key) {
            ++low;
        }
        // 右边找比key小的值
        while (low< high && a[high] >= key) {
            --high;
        }
        if (low < high) {
            // 找到之后交换左右的值
            int temp = a[low];
            a[low] = a[high];
            a[high] = temp;
        }
    }
    int temp = a[high];
    a[high] = a[end];
    a[end] = temp;
    return  low;
}
@end
