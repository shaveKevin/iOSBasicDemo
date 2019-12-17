//
//  SKFindFirstChar.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKFindFirstChar : NSObject
// 查找第一次出现的只出现一次的字符
char findFirstChar(char *cha);

int firstUniqChar(char * s);

@end

NS_ASSUME_NONNULL_END
