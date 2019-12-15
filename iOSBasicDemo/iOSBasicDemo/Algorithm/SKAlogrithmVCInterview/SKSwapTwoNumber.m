//
//  SKSwapTwoNumber.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/13.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSwapTwoNumber.h"

@implementation SKSwapTwoNumber


- (NSArray *)swapTempTwoNumber:(NSInteger )number1 number2:(NSInteger)number2 {
    NSInteger temp = number1;
    number1 = number2;
    number2 = temp;
    return @[@(number1),@(number2)];
}

- (NSArray *)swapAddTwoNumber:(NSInteger )number1 number2:(NSInteger)number2 {
    number1 = number2 + number1;
    number2 = number1 - number2;
    number1 = number1 - number2;
    return @[@(number1),@(number2)];
}

- (NSArray *)swapXorTwoNumber:(NSInteger )number1 number2:(NSInteger)number2 {
    number1 = number1^number2;
    number2 = number1^number2;
    number1 = number1^number2;
    return @[@(number1),@(number2)];
}
@end
