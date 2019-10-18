//
//  SKTraggedPointTest.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTraggedPointTest.h"


@interface SKTraggedPointTest ()

@end
@implementation SKTraggedPointTest

- (instancetype)init {
    
    if (self = [super init]) {
        NSNumber *number1 = @(0);
        NSNumber *bigNumber = @(999999999999999);
        NSString *string = @"5";
        NSString *longString = [[string mutableCopy]copy];
        NSMutableString *mutableString = [NSMutableString stringWithString:string];
        NSLog(@"number1 class is %@",[number1 class]);
        NSLog(@"bigNumber class is  %@",[bigNumber class]);
        NSLog(@"string class is  %@",[string class]);
        NSLog(@"longString class is  %@",[longString class]);
    }
    return self;
}




@end
