//
//  SKHappy.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/4/30.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 202. 快乐数
 编写一个算法来判断一个数 n 是不是快乐数。

 「快乐数」定义为：对于一个正整数，每一次将该数替换为它每个位置上的数字的平方和，然后重复这个过程直到这个数变为 1，也可能是 无限循环 但始终变不到 1。如果 可以变为  1，那么这个数就是快乐数。

 如果 n 是快乐数就返回 True ；不是，则返回 False 。

 示例：

 输入：19
 输出：true
 解释：
 12 + 92 = 82
 82 + 22 = 68
 62 + 82 = 100
 12 + 02 + 02 = 1

 */

/*
 思路：1.可以采用循环的方式，把每次得到的结果放到map中，每次循环得到的结果在map中进行匹配，如果字典中存在这个值，并且值不为1，说明产生了循环。不是快乐数。如果结果为1，是快乐数。
 2.使用快慢指针，如果发现快指针赶上慢指针了。说明产生了循环，如果值不为1，不是快乐数。
 */
@interface SKHappy : NSObject

bool isHappy(int n);

@end
