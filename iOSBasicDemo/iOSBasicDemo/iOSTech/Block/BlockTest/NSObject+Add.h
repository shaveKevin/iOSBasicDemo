//
//  NSObject+Add.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Add)

+ (NSInteger)sk_makeTool:(void(^)(BlockTool *))block;


@end

NS_ASSUME_NONNULL_END
