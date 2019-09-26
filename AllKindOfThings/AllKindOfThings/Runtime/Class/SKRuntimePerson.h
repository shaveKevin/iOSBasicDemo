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

- (void)takeAction;

- (void)testMsgSendAction;

@end

NS_ASSUME_NONNULL_END
