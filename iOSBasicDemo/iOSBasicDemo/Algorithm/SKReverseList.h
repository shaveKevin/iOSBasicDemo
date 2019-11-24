//
//  SKReverseList.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 单链表反转
//定义一个node的结构体
struct Node {
    int data;//数据
    struct Node *next;// 下一个指针地址
};

@interface SKReverseList : NSObject
// 单链表的反转(得到的是一个单链表)
struct Node * reverseNodeList(struct Node *head);
// 构造一个链表
struct Node *constructNodeList(void);
// 打印链表中的数据
void printNodeList(struct Node *head);

@end

NS_ASSUME_NONNULL_END
