//
//  SKArrayFindNum.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/16.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKArrayFindNum.h"

// 思路：可以通过遍历行和列 达到匹配度目的 也可以通过双向遍历来解决。一个从后往前一个从前往后进行遍历。 如果前面和后面遍历的时候只要得到对应的值就遍历完成，stop否则继续遍历。
@implementation SKArrayFindNum

- (instancetype)init {
    
    if (self = [super init]) {
        int array[4][4] = {{1,4,5,6},{2,3,7,9},{10,11,13,15},{12,18,19,20}};
         bool exist =   findNumFromArrayTwo(array, 4, 4,10);
        NSLog(@"exist is %@",@(exist));
        
    }
    return self;
}


bool findNumFromArray(int num[4][4],int row, int column,int result) {
    // 注意临界条件
    if (row > 0  && column > 0) {
        for (int i = 0 ; i < row; i ++) {
            for (int j = 0; j < column; j++) {
                if (num[i][j] == result) {
                    return true;
                }
            }
        }
    }
    return false;
}

bool findNumFromArrayTwo(int num[4][4],int row, int column,int result) {
    
    int rowR = 0;
    int columnR = column -1;
    // while循环 因为数组是有序的，所以这里可以根据遍历当前值和目标值做比较 进行coloumn和row的操作
    if (row > 0  && column > 0)  {
        while (rowR < row && columnR >=0) {
            if (num[rowR][columnR] == result) {
                return  true;
                break;
            } else if (num[rowR][columnR] > result) {
                --columnR;
            } else {
                ++rowR;
            }
        }
    }
    return false;
}

@end
