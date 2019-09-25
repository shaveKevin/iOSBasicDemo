//
//  SKPropertyTestModel.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKPropertyTestModel.h"

@interface SKPropertyTestModel ()

@property (nonatomic, copy) NSString *title;

@end

@implementation SKPropertyTestModel {
    NSString *_title;
}
// @synthesize title = _title;
- (void)setTitle:(NSString *)title{
    _title = title;
}

- (NSString *)title {
    return _title;
}

@end
