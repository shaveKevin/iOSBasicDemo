//
//  SKMergeSortedArray.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKMergeSortedArray.h"

@implementation SKMergeSortedArray

void mergeSortedArray(int a[], int aLen, int b[], int bLen,int result[]) {
    //  遍历数组a的指针
    int p = 0;
    // 遍历数组b的指针
    int q = 0;
    // 记录当前存储位置
    int i = 0;
    // 任一数组没有达到边界则进行遍历
    while (p<aLen && q<bLen) {
        // 如果a对应位置的值小于等于b数组对应位置的值那么把小的部分放入到指定的位置。
        if (a[p] <= b[q]) {
            // 存储a数组的值(小的)
            result[i] = a[p];
            //移动p的指针
             p++;
        } else {
            // 如果b位置对应的元素值小的话
            result[i] = b[q];
            // 移动q的指针
            q++;
        }
        // 指针合并结果的下一个存储位置
        i ++;
    }
    // 遍历完之后如果a数组有剩余 那么把a数组后面的全部放到结果数组的后面i++；
    while(p<aLen) {
        result[i] = a[p++];
        i++;
    }
    // 如果b数组有剩余,那么把b数组后面的全部放到结果数组的后面i++；
    while (q<bLen) {
        result[i] = b[q++];
        i ++;
    }
}
@end
