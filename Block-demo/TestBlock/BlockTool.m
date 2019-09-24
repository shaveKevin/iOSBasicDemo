//
//  BlockTool.m
//  TestBlock
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "BlockTool.h"

@implementation BlockTool

- (BlockTool * _Nonnull (^)(NSInteger))add {
    return ^(NSInteger value){
        self.result+= value;
        return self;
    };
}
- (BlockTool *(^)(NSInteger))minus {
    return ^(NSInteger value){
        self.result-= value;
        return self;
    };
}

@end
