//
//  SKRuntimePerson.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKRuntimePerson : NSObject

// 面试题:objc中向一个nil对象发送消息将会发生什么？
// 面试题:objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？
// 面试题：runtime如何通过selector找到对应的imp地址(分别考虑类方法和实例方法)

- (void)takeAction;

- (void)testMsgSendAction;

@end

NS_ASSUME_NONNULL_END
