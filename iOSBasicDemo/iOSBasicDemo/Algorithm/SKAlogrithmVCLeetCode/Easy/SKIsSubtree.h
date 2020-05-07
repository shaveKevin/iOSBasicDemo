//
//  SKIsSubtree.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/5/7.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 572. 另一个树的子树
 给定两个非空二叉树 s 和 t，检验 s 中是否包含和 t 具有相同结构和节点值的子树。s 的一个子树包括 s 的一个节点和这个节点的所有子孙。s 也可以看做它自身的一棵子树。

 示例 1:
 给定的树 s:

      3
     / \
    4   5
   / \
  1   2
 给定的树 t：

    4
   / \
  1   2
 返回 true，因为 t 与 s 的一个子树拥有相同的结构和节点值。

 示例 2:
 给定的树 s：

      3
     / \
    4   5
   / \
  1   2
     /
    0
 给定的树 t：

    4
   / \
  1   2
 返回 false。

 */
NS_ASSUME_NONNULL_BEGIN

struct SubTreeNode {
    int val;
    struct SubTreeNode *left;
    struct SubTreeNode *right;
};

@interface SKIsSubtree : NSObject

bool isSubtree(struct SubTreeNode* s, struct SubTreeNode* t);

@end

NS_ASSUME_NONNULL_END
