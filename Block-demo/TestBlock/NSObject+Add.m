//
//  NSObject+Add.m
//  TestBlock
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "NSObject+Add.h"

@implementation NSObject (Add)
+ (NSInteger)sk_makeTool:(void (^)(BlockTool *))block {
    BlockTool *blockTool = [[BlockTool alloc]init];
    block(blockTool);
    return blockTool.result;
}
@end
