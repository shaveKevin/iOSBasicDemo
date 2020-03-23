//
//  SKIntersect.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/22.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKIntersect.h"

@implementation SKIntersect
// 先进行排序然后进行位置定位
// 排序(先写一个比较函数) 这样写防止了溢出
int compareMethod(const void *a, const void *b) {
    // 如果a>b 返回1  默认从小到大排列
    if (*(int *)a > * (int *)b)  {
        return  1;
    }  else if (*(int *)a < * (int *)b)  {
        return  -1;
    }
    return 0;
}
int* intersect(int* nums1, int nums1Size, int* nums2, int nums2Size, int* returnSize){
    // 排序
    qsort(nums1, nums1Size, sizeof(nums1[0]), compareMethod);
    qsort(nums2, nums2Size, sizeof(nums2[0]), compareMethod);
    int t = 0;
    // 排序之后对两个数组进行遍历，把一致的放到数组1中
    for (int i = 0,j = 0; (i < nums1Size && j<nums2Size);) {
        if (nums1[i] == nums2[j]) {
            nums1[t] = nums1[i];
            t++;
            i++;
            j++;
        } else if (nums1[i]> nums2[j]) {
            j++;
        } else {
            i++;
        }
    }
    *returnSize = t;
    int *temp =  (int *)malloc(t*sizeof(int));
    if (!temp) {
        printf("malloc  failed");
        return NULL;
    }
    for (int m = 0; m < t; m ++) {
        temp[m] = nums1[m];
    }
    return temp;

}

@end
