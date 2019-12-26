//
//  SKAliveThread.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ExuteBlock)(void);

@interface SKAliveThread : NSObject
/**
 开启一个线程
 */
- (void)run;

/**
 当前子线程执行一个任务
 */
- (void)executeTaskWithBlock:(ExuteBlock)task;

/**
 结束一个线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
