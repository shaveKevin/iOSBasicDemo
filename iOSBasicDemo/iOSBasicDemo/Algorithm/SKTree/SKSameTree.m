//
//  SKSameTree.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/28.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSameTree.h"
// 定义treeNode的结构题
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
    struct TreeNode *parent;
};


@interface SKSameTree ()
{
    struct TreeNode root;
}
@end
@implementation SKSameTree


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

// 二叉搜索树才可以执行这个
//  前序遍历:先遍历root,然后遍历左子树，再遍历右子树。 调用的时候先传入root 应用：打印二叉树  判断一个二叉树是不是完全二叉树
void preorderTraversal(struct TreeNode *node) {
    if (node == NULL)  return;
    NSLog(@"node  val is  %d",node->val);
    preorderTraversal(node->left);
    preorderTraversal(node->right);
}

// 中序遍历：先遍历左子树，再遍历root 最后遍历右子树  应用：判断一个二叉树是不是完全二叉树
void inorderTraversal(struct TreeNode *node) {
    if (node == NULL)  return;
    inorderTraversal(node->left);
    NSLog(@"node  val is  %d",node->val);
    inorderTraversal(node->right);
}

// 后序遍历:先遍历左子树或者右子树，最后访问根结点  应用：判断一个二叉树是不是完全二叉树
void postorderTraversal(struct TreeNode *node) {
    if (node == NULL)  return;
    postorderTraversal(node->left);
    postorderTraversal(node->right);
    NSLog(@"node  val is  %d",node->val);
}
// 层序遍历：从上往下 从左到右依次访问每一个结点
// 思路：使用队列 1.将根结点入队 2. 循环执行下面操作，直到队列为空。(将头结点a出队，进行访问。 将a的左子结点入队，将a的右子结点 入队)

@end
