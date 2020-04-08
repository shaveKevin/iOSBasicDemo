//
//  SKFindCommonView.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKFindCommonView.h"

@implementation SKFindCommonView

- (NSArray <UIView *>*)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther {
    // 定义共同父视图的数组
    NSMutableArray *resultsArray = [NSMutableArray array];
    //  查找两个类中的所有父视图
    NSArray *viewOneArray = [self findSuperView:viewOne];
    NSArray *viewOtherArray = [self findSuperView:viewOther];
    // 定义循环变量
    int i = 0;
    // 定义循环条件
    while (i < MIN(viewOneArray.count, viewOtherArray.count)) {
        // 通过倒序方式获取各个视图的父视图
        UIView *superOne = viewOneArray[viewOneArray.count-i-1];
        UIView *superOther = viewOtherArray[viewOtherArray.count-i-1];
        // 如果两个视图相等 那么是公共父视图
        if (superOne == superOther) {
            [resultsArray addObject:superOne];
            i ++;
        } else {
            // 如果不相等，结束遍历。
            break;
        }
    }
    return resultsArray;
}
- (NSArray *)findSuperView:(UIView *)view{
    // 定义所有父视图的数组
    NSMutableArray *viewOneSuperArray = [NSMutableArray array];
    // 初始化为第一父视图
    UIView *tempVieW = view.superview;
    while (tempVieW) {
        [viewOneSuperArray addObject:tempVieW];
        // 顺着supview指针一直向上查找
        tempVieW = tempVieW.superview;
    }
    return viewOneSuperArray;
}

@end
