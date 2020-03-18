//
//  SKMaxProfit.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/18.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKMaxProfit.h"

@implementation SKMaxProfit

int maxProfit(int* prices, int pricesSize){
    int maxP = 0;
    // 可以画一个xy轴 画出上升曲线，把所有上升的地方加起来就可以了。   遍历一遍只要后面的大于前面的卖了就好。
    for (int i = 1; i < pricesSize; i++) {
        if (prices[i] > prices[i - 1])
            maxP += prices[i] - prices[i - 1];
    }
    return maxP;
}

@end
