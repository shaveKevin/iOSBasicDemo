//
//  SKSameTree.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/28.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSameTree.h"

@implementation SKSameTree
// 定义treeNode的结构题
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};
// 采用递归的方式进行判断
bool isSameTree(struct  TreeNode *p, struct TreeNode *q) {
   // 首先判断两个是否都为空 两个都为空树的话 说明一样
    if (p  == NULL && q == NULL) {
        return  true;
    }
    // 如果两个都不为空 但是有一个为空，那么就为空
    if (p == NULL ||q == NULL) {
           return  false;
       }
    // 判断树上的值是否相同
    if (p->val != q->val) {
        return  false;
    }
    // 通过递归判断对应位置的左子树和右子树是否相同，一定要全都相等才可以
    return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
}

@end
