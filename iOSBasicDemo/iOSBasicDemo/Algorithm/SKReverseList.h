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
struct Node {
    int data;
    struct Node *next;
}

@interface SKReverseList : NSObject

@end

NS_ASSUME_NONNULL_END
