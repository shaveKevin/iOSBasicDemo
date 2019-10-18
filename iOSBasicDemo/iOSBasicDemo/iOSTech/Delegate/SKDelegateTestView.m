//
//  SKDelegateTestView.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKDelegateTestView.h"

@implementation SKDelegateTestView

- (instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(testDelegateObjcControl)]) {
        [self.delegate testDelegateObjcControl];
    }
}

@end
