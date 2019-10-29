//
//  SKBasicAlogrithmVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/29.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKBasicAlogrithmVC.h"

@interface SKBasicAlogrithmVC ()

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@end

@implementation SKBasicAlogrithmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    [self privateMethod];
    
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *viewSuper = [[UIView alloc]init];
    viewSuper.frame = CGRectMake(100, 20, 200, 100);
    viewSuper.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:viewSuper];
    
    self.view1 = [[UIView alloc]init];
    self.view1.backgroundColor = [UIColor redColor];
    self.view1.frame = CGRectMake(0, 0, 50, 30);

    [viewSuper addSubview:self.view1];
    self.view2 = [[UIView alloc]init];
    self.view2.backgroundColor = [UIColor orangeColor];
    self.view2.frame = CGRectMake(0, 40, 50, 30);
    [viewSuper addSubview:self.view2];
        
}

- (void)setupData {
    
}

- (void)setupLayout {
    
}

- (void)privateMethod {
    
    [self findCommonViews];
}
// 解法1:
- (void)findCommonViews {
    // 找出v1所有的父视图
    NSMutableArray *array1 = [NSMutableArray array];
    UIView *tempView1 = self.view1;
    while (tempView1.superview) {
        [array1 addObject:tempView1];
        tempView1 = tempView1.superview;
    }
    
    // 找出v2所有的父视图
    NSMutableArray *array2 = [NSMutableArray array];
    UIView *tempView2 = self.view2;
    while (tempView2.superview) {
        [array2 addObject:tempView2];
        tempView2 = tempView2.superview;
    }
    NSInteger i = 0;
    NSMutableArray *resultArray  = [NSMutableArray array];
    while (i < MIN(array1.count, array2.count)) {
    // 从最后一个视图开始遍历 因为顶层的是UIWindow
        UIView *supwerView1 = array1[array1.count - 1-i];
        UIView *supwerView2 = array2[array2.count - 1-i];
        if (supwerView1 == supwerView2) {
            NSLog(@"公共视图为: %@",supwerView1);
            [resultArray addObject:supwerView1];
            i++;
        } else {
            // 如果不相等说明没有公共视图了
            break;
        }
    }
    NSLog(@"公共视图总数为：%@",@(resultArray.count));
   
}
// 算法题分析：1.查找两个View的公共父控件
/*
    答：这道题思路很明确：既然要找出两个view的公共父控件 首先分别找出两个view的superview放到数组里。
       然后问题就变成了，找出两个数组之间的公共元素(不唯一的公共元素)。
*/
@end
