//
//  SKLinkListNode.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/29.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKLinkListNode : NSObject

@property (nonatomic, copy) NSString  *name;

@property (nonatomic, strong) SKLinkListNode *next;

// 反转链表
- (void)turnOverLinkList;

@end

NS_ASSUME_NONNULL_END
