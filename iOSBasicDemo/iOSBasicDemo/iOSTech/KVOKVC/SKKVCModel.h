//
//  SKKVCModel.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/30.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKKVCTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKKVCModel : NSObject

@property (nonatomic, copy) NSString  *name;

@property (nonatomic, assign) NSInteger  age;

@property (nonatomic, copy) NSString  *userId;

@property (nonatomic, strong) SKKVCTestModel *model;

@end

NS_ASSUME_NONNULL_END
