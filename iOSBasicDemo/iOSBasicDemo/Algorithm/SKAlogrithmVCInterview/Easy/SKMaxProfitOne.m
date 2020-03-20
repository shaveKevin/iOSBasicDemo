//
//  SKMaxProfitOne.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/21.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKMaxProfitOne.h"

@implementation SKMaxProfitOne
int maxProfitOne(int* prices, int pricesSize){
    int maxP = 0;
    for (int i = 0; i <pricesSize; i++) {
        for (int j = i+1; j < pricesSize; j++) {
            if (prices[j]-prices[i] > maxP) {
                maxP = prices[j]-prices[i];
            }
            
        }
    }
    return maxP;
}

int maxProfitCycle(int* prices, int pricesSize){
    if(pricesSize == 0) return 0;
    int maxP = 0;
    int lowPrice = prices[0];
    for (int i = 1; i <pricesSize; i++) {
        if (prices[i] < lowPrice) {
            lowPrice =prices[i];
            continue;
        }
        if (prices[i]- lowPrice > maxP) {
            maxP = prices[i]- lowPrice;
        }
    }
    return maxP;
}

@end
