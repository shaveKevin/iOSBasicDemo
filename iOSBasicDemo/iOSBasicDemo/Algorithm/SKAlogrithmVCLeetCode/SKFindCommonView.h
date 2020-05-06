//
//  SKFindCommonView.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 算法题分析：1.查找两个View的公共父控件
/*
    答：这道题思路很明确：既然要找出两个view的公共父控件 首先分别找出两个view的superview放到数组里。
       然后问题就变成了，找出两个数组之间的公共元素(不唯一的公共元素)。这里采用倒序的方式进行对比。
*/
@interface SKFindCommonView : NSObject

- (NSArray <UIView *>*)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther;
@end

NS_ASSUME_NONNULL_END
