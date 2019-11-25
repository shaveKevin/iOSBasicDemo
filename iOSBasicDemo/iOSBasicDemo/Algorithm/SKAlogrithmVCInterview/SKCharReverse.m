//
//  SKCharReverse.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKCharReverse.h"

@implementation SKCharReverse

void charReverse(char *cha) {
    // 指向第一个字符
    char *begin = cha;
    // 指向最后一个字符
    char *end = cha + strlen(cha)-1;
    while (begin< end) {
        // 交换两个字符 同时移动指针
        char temp = *begin;        
        *(begin ++) = *end;
        *(end --) = temp;
    }
}
@end
