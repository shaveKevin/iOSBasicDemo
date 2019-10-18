//
//  BlockTest.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/2.
//  Copyright © 2019 小风. All rights reserved.
//

#import "BlockTest.h"

@implementation BlockTest

- (void)actionBlock {
    
    if (self.block0) {
        self.block0();
    }
    if (self.blockHaha) {
        self.blockHaha(@"block o o ");
    }
    
    if (self.ActionBlock2) {
       NSString *strhah =  self.ActionBlock2(@"哈哈哈", @"看看吧");
        NSLog(@"%@",strhah);
    }
    
}
- (void)testBlock1:(void (^)(NSString * _Nonnull))action {
    if (action) {
        action(@"xxxx");
    }
}
@end
