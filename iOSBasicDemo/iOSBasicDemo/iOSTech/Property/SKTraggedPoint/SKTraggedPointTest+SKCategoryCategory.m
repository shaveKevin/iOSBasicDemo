//
//  SKTraggedPointTest+SKCategoryCategory.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/4.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTraggedPointTest+SKCategoryCategory.h"


@implementation SKTraggedPointTest (SKCategoryCategory)
+(void)load {
    NSLog(@"我是当前类分类的另一个load");
}
+ (void)initialize {
    NSLog(@"我是当前类分类的另一个initialize");
}
@end
