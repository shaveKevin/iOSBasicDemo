//
//  SKKVOStudentModel.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/28.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKKVOStudentModel : NSObject
{
    NSString *_stdAge;
}
- (void)setStdAge:(NSString *)stdAge;

- (NSString *)stdAge;

@property (nonatomic, copy) NSString  *stdName;

@end

NS_ASSUME_NONNULL_END
