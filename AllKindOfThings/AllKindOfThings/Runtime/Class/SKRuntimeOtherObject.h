//
//  SKRuntimeOtherObject.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKRuntimeOtherObject : NSObject

- (void)testUnrecognizedSelector;

- (void)stepThreeUnrecognizedSelector;


- (NSString *)stepThreeUnrecognizedSelectorTwo:(NSString *)one two:(NSString *)two;

- (NSArray *)stepThreeUnrecognizedSelectorThree:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
