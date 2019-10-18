//
//  BlockTool.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockTool : NSObject

@property (nonatomic, assign) NSInteger result;

- (BlockTool *(^)(NSInteger))add;

- (BlockTool *(^)(NSInteger))minus;


@end

NS_ASSUME_NONNULL_END
