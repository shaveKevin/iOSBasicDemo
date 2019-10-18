//
//  TestExpand+Additions.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/8/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import "TestExpand.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestExpand (Additions)

@property(nonatomic, copy) NSString *mustProperty;

- (void)testExpanded;

@end

NS_ASSUME_NONNULL_END
