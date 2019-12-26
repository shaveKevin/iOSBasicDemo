//
//  SKBasicSortObj.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/16.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
//  面试题：简述排序算法 - 快排  partion函数的原理 堆排(不稳定) 归并排序 基数排序
NS_ASSUME_NONNULL_BEGIN

@interface SKBasicSortObj : NSObject


/**
 冒泡排序
 时间复杂度：O(n^2)
 */
void bubbldSort (int array[_Nonnull],int length);

@end

NS_ASSUME_NONNULL_END
