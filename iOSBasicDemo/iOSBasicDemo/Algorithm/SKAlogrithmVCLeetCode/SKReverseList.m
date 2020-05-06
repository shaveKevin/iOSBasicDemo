//
//  SKReverseList.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKReverseList.h"

@implementation SKReverseList
// 使用头插法进行单链表的反转
struct Node * reverseNodeList(struct Node *head) {
    // 定义遍历指针，初始化为头结点
    struct Node *p = head;
    // 定义反转链表的头部
    struct Node *newH = NULL;
    // 遍历链表
    while (p != NULL) {
        // 记录下一个结点
        struct Node *temp = p->next;
        // 当前结点的next指向新链表的头部
        p->next = newH;
        // 更改新链表的头部为当前结点
        newH = p;
        // 移动p指针
        p = temp;
        
    }
    return newH;
}

// 构造链表
struct Node *constructNodeList(void) {
    //定义头结点
    struct Node *head = NULL;
    // 记录当前尾结点
    struct Node *cur = NULL;
    
    for (int i = 1; i < 6; i++) {
        // 为链表的结点分配空间
        struct Node *node = malloc(sizeof(struct Node));
        // 为结点赋值
        node->data = i;
        //如果头结点为空，新结点就为头结点
        if (head == NULL) {
            head = node;
        } else {
            // 当前结点的next为新结点
            cur->next = node;
            
        }
        // 设置当前结点为新结点
        cur = node;
        
    }
    return head;
    
}
void printNodeList(struct Node *head) {
    //初始化头结点
    struct Node *temp = head;
    // 如果结点不为NULL 继续遍历 NULL就结束了。
    while (temp != NULL) {
        printf("node is %d\n",temp->data);
        temp = temp->next;
    }
}




struct ListNode {
    int val;
   struct ListNode *next;
};

struct ListNode* reverseList(struct ListNode* head){
    struct ListNode *p = head;
    struct ListNode *newH = NULL;
    while (p!= NULL) {
        struct ListNode *temp = p->next;
        p->next = newH;
        newH = p;
        p = temp;
    }
    return newH;
}

struct  ListNode *reverseListNode (struct ListNode *head) {
    
    if (head == NULL || head->next == NULL) {
        return head;
    }
    // 其实这个解法就相当于双向链表的前驱和后继 找到前驱和后继就可以进行指针的指向
    struct ListNode *prevNode = NULL;
    struct ListNode *nextNode = NULL;
    while (head!= NULL) {
        nextNode = head->next;
        head->next = prevNode;
        prevNode = head;
        head = nextNode;
    }
    return prevNode;
}

@end
