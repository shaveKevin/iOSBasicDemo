//
//  SKValidParentheses.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/30.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 算法题：有效的括号
/**
 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。

 有效字符串需满足：

 左括号必须用相同类型的右括号闭合。
 左括号必须以正确的顺序闭合。
 注意空字符串可被认为是有效字符串。
 示例 1:

 输入: "()"
 输出: true
 示例 2:

 输入: "()[]{}"
 输出: true
 示例 3:

 输入: "(]"
 输出: false
 示例 4:

 输入: "([)]"
 输出: false
 示例 5:

 输入: "{[]}"
 输出: true
 
 https://leetcode-cn.com/problems/valid-parentheses/
 */
// 分析：这道题有很多种解法：
//  1.其中一种是遍历字符串如果遇到[] {} （） 就把它们都替换成空字符串 最后判断替换后的字符串长度是否大于0 如果大于0 说明 不符合题意。如果等于0 说明符合题意。
// 2.利用栈的思想，遍历字符串把字符串的每个字符放入到栈中push，然后遍历字符串遇到]})就pop，将pop得到的字符与遍历对应 的字符进行对比，如果不一致。说明不符合题意。如果最后发现stack为空，那么就说明符合题意，如果不为空不符合题意。

@interface SKValidParentheses : NSObject

bool isValid(char * s);

@end

NS_ASSUME_NONNULL_END
