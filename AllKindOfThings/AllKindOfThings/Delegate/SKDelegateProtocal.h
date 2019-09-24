//
//  SKDelegateProtocal.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import <UIKIt/UIKit.h>
#import <Foundation/Foundation.h>


@protocol SKDelegateProtocal <NSObject>

@property (nonatomic, copy)  NSString *nameProperty;

- (void)testControl;

@end
