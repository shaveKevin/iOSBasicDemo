//
//  SKPropertyTestModel.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 面试题：用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
@interface SKPropertyTestModel : NSObject

@property (nonatomic, copy) NSString *title;


- (void)takeActions;

@end

NS_ASSUME_NONNULL_END
