
//
//  RetainCycleModule.m
//  TestBlock
//
//  Created by shavekevin on 2019/9/10.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "RetainCycleModule.h"
typedef void(^ModuleBlock)(void);

@interface RetainCycleModule ()

@property (nonatomic, strong) ModuleBlock moduleBlock;

@end

@implementation RetainCycleModule

- (instancetype)init {
    
    __block id tep = self;
    if (self = [super init]) {
        self.moduleBlock =^(){
            NSLog(@"self = %@",tep);
            tep = nil;
        };
    }
    return self;
}
- (void)excuteBlock {
    self.moduleBlock();
}


@end
