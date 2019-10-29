//
//  NSObject+SKKVO.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/28.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SKObservingBlock)(id observedObject, NSString * observeKey, id oldValue, id newValue);

@interface NSObject (SKKVO)

- (void)sk_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(SKObservingBlock)block;

- (void)sk_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
