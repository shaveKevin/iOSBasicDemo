//
//  SKIsSubtree.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2020/5/7.
//  Copyright © 2020 小风. All rights reserved.
//

#import "SKIsSubtree.h"


@implementation SKIsSubtree

bool isSubtree(struct SubTreeNode* s, struct SubTreeNode* t) {
    if (s == NULL) return false;
       return checkNodeValid(s, t)|| isSubtree(s->left, t)||isSubtree(s->right, t);
    
}

// 校验是否合法
bool checkNodeValid (struct SubTreeNode* s, struct SubTreeNode* t) {
    
    if (s == NULL && t == NULL)  return true;
    if ((s== NULL && t!=NULL)||(s != NULL && t == NULL)||(s->val != t->val) ) return false;
    return checkNodeValid(s->left, t->left)&&checkNodeValid(s->right, t->right);
}

@end
