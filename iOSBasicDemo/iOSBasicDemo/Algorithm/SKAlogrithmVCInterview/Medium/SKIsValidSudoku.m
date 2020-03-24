//
//  SKIsValidSudoku.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/24.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKIsValidSudoku.h"

// C 库函数 void *memset(void *str, int c, size_t n) 复制字符 c（一个无符号字符）到参数 str 所指向的字符串的前 n 个字符。

@implementation SKIsValidSudoku
// 如果当前数独中有'.'字符 把它设置为-1。
int trans(char cur) {
    if (cur == '.') {
        return -1;
    } else {
        return cur - '1';
    }
}

// 九宫格是否合法
bool isSqureValid (char** board, int boardSize, int* boardColSize) {
    int i , j , k;
    int x,y;
    int  inx;
    int hash[9];
    for (i = 0 ; i < 9; i ++) {
        x = (i/3)*3;
        y = (i% 3)*3;
        memset(hash, 0x00, sizeof(int)*9);
        for (j = x; j <x+3; j++) {
            for (k = y;k < y+3; k++) {
                inx = trans(board[j][k]);
                if (inx == -1) {
                    continue;
                }
                if (hash[inx]!=0) {
                    return  false;
                }
                hash[inx] ++;
            }
        }
    }
    return true;
}

// 行是否合法
bool isRowValid(char** board, int boardSize, int* boardColSize) {
    int i,j;
    int hash[9];
    int inx;
    for (i = 0; i < 9; i ++) {
        memset(hash, 0x00, sizeof(int)*9);
        for (j = 0; j < 9; j ++) {
            inx = trans(board[i][j]);
            if (inx == -1) {
                continue;
            }
            if (hash[inx]!=0) {
                return  false;
            }
            hash[inx] ++;
        }
    }
    return true;
}


// 列是否合法
bool isColumnValid(char** board, int boardSize, int* boardColSize) {
    int i,j;
    int hash[9];
    int inx;
    for (i = 0; i < 9; i ++) {
        memset(hash, 0x00, sizeof(int)*9);
        for (j = 0; j < 9; j ++) {
            inx = trans(board[j][i]);
            if (inx == -1) {
                continue;
            }
            if (hash[inx]!=0) {
                return  false;
            }
            hash[inx] ++;
        }
    }
    return true;
}

bool isValidSudoku(char** board, int boardSize, int* boardColSize){
    
    return isSqureValid(board, boardSize, boardColSize) && isRowValid(board, boardSize, boardColSize)&& isColumnValid(board, boardSize, boardColSize);
}

@end
