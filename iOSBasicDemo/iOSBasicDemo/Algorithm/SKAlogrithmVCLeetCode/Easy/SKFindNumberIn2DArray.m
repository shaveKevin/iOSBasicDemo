//
//  SKFindNumberIn2DArray.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/4/13.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKFindNumberIn2DArray.h"

@implementation SKFindNumberIn2DArray
// 从右上角开始计算  构造一个坐标系坐标分布,如果目标值大于当前值 那么就把row++ 向下去查找，如果小于当前值，让column 进行自减在左半区域查找。
bool findNumberIn2DArray(int** matrix, int matrixSize, int* matrixColSize, int target){
    if (matrix == NULL || matrixSize <=0 || *matrixColSize == 0) {
        return false;
    }
    int row = 0,column = *matrixColSize -1;
    while (row<= matrixSize-1 && column >=0) {
        if (target == matrix[row][column]) {
            return  true;
        } else if (target > matrix[row][column]) {
            row ++;
        }else {
            column--;
        }
    }
    return  false;
}

@end
