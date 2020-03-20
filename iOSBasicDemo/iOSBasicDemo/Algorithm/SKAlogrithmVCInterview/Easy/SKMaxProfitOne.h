//
//  SKMaxProfitOne.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/21.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 买卖股票的最佳时机
 给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。

 如果你最多只允许完成一笔交易（即买入和卖出一支股票一次），设计一个算法来计算你所能获取的最大利润。

 注意：你不能在买入股票前卖出股票。

  

 示例 1:

 输入: [7,1,5,3,6,4]
 输出: 5
 解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
      注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格。
 示例 2:

 输入: [7,6,4,3,1]
 输出: 0
 解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
 链接：https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/
 解法可以采用暴力法：双层for循环。 还可以采用单层for循环。假设一个值为最低的价格，然后遍历数组，如果遍历的价格比最低的价格还低那么重新给最低价格赋值。如果高 那么计算收益。
 */
NS_ASSUME_NONNULL_BEGIN

@interface SKMaxProfitOne : NSObject

int maxProfitOne(int* prices, int pricesSize);

@end

NS_ASSUME_NONNULL_END
