//
//  TestExpand.m
//  TestBlock
//
//  Created by shavekevin on 2019/8/14.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import "TestExpand.h"

@implementation TestExpand
@synthesize mustProperty = _mustProperty;

- (void)setMustProperty:(NSString *)mustProperty {
    NSLog(@"这是类自己的===mustProperty");

    mustProperty = mustProperty;
}
- (NSString *)mustProperty {
    NSLog(@"这是类自己的");
    return _mustProperty;
}

- (void)testExpanded {
    NSLog(@"这是类里面的=======testExpanded");
}

@end
