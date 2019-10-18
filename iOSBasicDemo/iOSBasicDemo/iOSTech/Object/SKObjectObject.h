//
//  SKObjectObject.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 面试题：objc中的类方法和实例方法有什么本质区别和联系？
@interface SKObjectObject : NSObject


@property (nonatomic, strong) NSString *ObjectObjectString;

- (void)printObjectObject;

+ (void)thisisSuperMethod;

- (id)printClass;

@end

NS_ASSUME_NONNULL_END
