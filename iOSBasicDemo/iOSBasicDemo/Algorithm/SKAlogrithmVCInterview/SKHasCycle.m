//
//  SKHasCycle.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/18.
//  Copyright © 2019 小风. All rights reserved.
//


typedef struct node{
    int data;
    struct node *next;
}Node,*LinkList;

#import "SKHasCycle.h"

@implementation SKHasCycle

- (void)hasCycle {
    
    LinkList linkList;
    initLinkList(&linkList);
    randomNode(&linkList,10);
    randomCir(&linkList,10);//随机产生一个环
    bool hasMoreCycle = hasCycleMore(linkList);
    if (hasMoreCycle) {
        NSLog(@"hasCycleMore=有环");
        
    } else {
        NSLog(@"hasCycleMore=没有环");
    }
}

bool hasCycleMore(struct node *head) {
    // 使用快慢指针来处理
    struct node *slow = head;
    struct node *fast = head;
    if (slow == NULL|| fast->next== NULL) {
        return  false;
    }
    // 注意判空操作
    while (slow != NULL && fast != NULL&& fast->next != NULL) {
        slow = slow->next;
        fast = fast->next->next;
        if (fast == slow) {
            return true;
        }
    }
    return false;
}

void randomCir(LinkList *pNode, int i) {
    Node * pn = (*pNode)->next;
    srand((unsigned)time(NULL));//置随机数种子

    int k = rand()%i;//在 0-i内随机找一个位置
    int n=0;
    while(pn->next && n<k) {
        n++;
        pn = pn->next;
    }
    pn->next = (*pNode)->next->next;//随机一节点与第二个节点接上，形成闭合环路
}

void randomNode(LinkList *pNode, int i) {
    srand((unsigned)time(NULL));//置随机数种子
    for(int k=0;k<i;k++)
        addNode(*pNode, rand() % i);
}

//用头插法
void addNode(LinkList linkList,int val) {
    Node * n = (Node *)malloc(sizeof(Node));
    n->data = val;
    n->next = linkList->next;
    linkList->next = n;
}
//链表的初始化操作
void initLinkList(Node ** linkList) {
    (*linkList) = (Node *)malloc(sizeof(Node));
    (*linkList)->next = NULL;
}

@end
