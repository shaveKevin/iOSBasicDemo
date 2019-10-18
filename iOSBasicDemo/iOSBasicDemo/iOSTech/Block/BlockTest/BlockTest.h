//
//  BlockTest.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN


typedef void(^ActionBlock0)(void);
//  定义一个block  返回值为void  名字为ActionBlock 参数为id sender  简单block
typedef void(^ActionBlock)(id sender);

//  当block 作为返回参数的时候
//typedef NSString *(^ActionBlock2)(NSString *argu1, NSString *argu2);

@interface BlockTest : NSObject


@property (nonatomic, copy) ActionBlock0 block0;

@property (nonatomic, copy) ActionBlock blockHaha;

//@property (nonatomic, copy) ActionBlock2 blockTwo;

@property (nonatomic, copy) NSString *(^ActionBlock2)(NSString *argu1, NSString *argu2);

- (void)actionBlock;
// block当做返回值
- (void)testBlock1:(void(^)(NSString *))action;

@end

NS_ASSUME_NONNULL_END
