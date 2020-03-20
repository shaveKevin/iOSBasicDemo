//
//  SKMaxProfit.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/18.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKMaxProfitTwo.h"

@implementation SKMaxProfitTwo
// 贪心算法来处理
int maxProfit(int* prices, int pricesSize){
    int maxP = 0;
    // 可以画一个xy轴 画出上升曲线，把所有上升的地方加起来就可以了。遍历一遍只要后面的大于前面的卖了就好。
    for (int i = 1; i < pricesSize; i++) {
        if (prices[i] > prices[i - 1])
            maxP += prices[i] - prices[i - 1];
    }
    return maxP;
}
/*
 分析：这里采用的是贪心算法，也就是说拿今天的价格减去昨天的价格无非是三种情况 1.正数 2.负数 3.0 我们使用贪心就是找到最优解，也即是说今天的价格收益不影响昨天的也不影响明天的。我们只需要知道今天卖了能赚到钱就好。这只是一个局部最优解。
 */

// 什么是贪心算法？
/*
 百度百科是这样解释的：贪心算法（又称贪婪算法）是指，在对问题求解时，总是做出在当前看来是最好的选择。也就是说，不从整体最优上加以考虑，他所做出的是在某种意义上的局部最优解。
 贪心算法不是对所有问题都能得到整体最优解，关键是贪心策略的选择，选择的贪心策略必须具备无后效性，即某个状态以前的过程不会影响以后的状态，只与当前状态有关。
 
 */

// 暴力解法
int maxProfitForce(int* prices, int pricesSize) {
    return 0;
}

@end
