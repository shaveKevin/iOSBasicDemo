//
//  SKLevelOrder.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/3/22.
//  Copyright © 2020 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 面试题32 - I. 从上到下打印二叉树
 从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

  

 例如:
 给定二叉树: [3,9,20,null,null,15,7],

     3
    / \
   9  20
     /  \
    15   7
 返回：

 [3,9,20,15,7]
  

 提示：

 节点总数 <= 1000
 链接：https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/
 */
NS_ASSUME_NONNULL_BEGIN

@interface SKLevelOrder : NSObject

int* levelOrder(struct TreeNode* root, int* returnSize);

@end

NS_ASSUME_NONNULL_END
