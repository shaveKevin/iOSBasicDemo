//
//  SKValidParentheses.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/30.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKValidParentheses.h"

@implementation SKValidParentheses

bool isValid(char * s) {
    // 如果字符串为空就直接返回false
    if (s == NULL || s[0] == '\0') return  false;
    long length = strlen(s);
    // 如果长度不是偶数直接返回false
    if (length %2 > 0) return  false;
    char *stack = (char *)malloc(strlen(s))+1;
    int top = 0;
    for (int i = 0; s[i]; i++) {
        if (s[i] == '(' || s[i] == '[' || s[i] == '{') {
            stack[++top] = s[i];
            
        } else if((s[i] == (stack[top] + 1))||(s[i] == (stack[top] + 2))) {
            top--;
        }  else {
            return false;
        }
    }
    free(stack);
    return  (!top);
}

@end
