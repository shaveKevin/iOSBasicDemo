//
//  SKSwapTwoNumber.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/13.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 算法题：交换两个数字  1. 用临时变量 2. 用加法 运算 3. 用异或来做
@interface SKSwapTwoNumber : NSObject

// 1. 临时变量
- (NSArray *)swapTempTwoNumber:(NSInteger )number1 number2:(NSInteger)number2;
// 2. 加法运算
- (NSArray *)swapAddTwoNumber:(NSInteger )number1 number2:(NSInteger)number2;
// 3.异或运算
- (NSArray *)swapXorTwoNumber:(NSInteger )number1 number2:(NSInteger)number2;

@end

NS_ASSUME_NONNULL_END
