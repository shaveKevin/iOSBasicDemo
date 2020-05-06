//
//  SKHasCycle.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
// 面试题：给定一个链表，判断链表中是否有环。.为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 pos 是 -1，则在该链表中没有环。
NS_ASSUME_NONNULL_BEGIN

@interface SKHasCycle : NSObject


- (void)hasCycle;

@end

NS_ASSUME_NONNULL_END
