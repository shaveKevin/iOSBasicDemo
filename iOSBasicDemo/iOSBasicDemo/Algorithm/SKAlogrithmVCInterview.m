//
//  SKAlogrithmVCInterview.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKAlogrithmVCInterview.h"
#import "SKCharReverse.h"
#import "SKReverseList.h"
#import "SKMergeSortedArray.h"
#import "SKFindFirstChar.h"
#import "SKFindCommonView.h"
#import "SKFindMiddleCount.h"
#import "SKSwapTwoNumber.h"
#import "SKArrayFindNum.h"

// 两个大数相加
@interface SKAlogrithmVCInterview ()

@property (nonatomic, strong) UIView *view1;

@property (nonatomic, strong) UIView *view2;

@end

@implementation SKAlogrithmVCInterview

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    
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
    // 字符串反转
    [self charReverse];
    // 单链表反转
    [self reverseNodeList];
    // 有序数组的合并
    [self mergeSortedArray];
    // 查找字符串第一个只出现一次的字符
    [self findFirstChar];
    //查找两个View的公共父控件
    [self findCommonView];
    // 无序数组中查找中位数
    [self findMiddleCount];
    // 交换两个数
    [self swapTwoNumber];
    // 找出有序数组中的指定值
    [self arrayFindNum];
}

- (void)setupLayout {
    
}


- (void)charReverse {
    char ch[] = "hello,world";
    charReverse(ch);
    printf("reverse result is %s \n",ch);
}

- (void)reverseNodeList {
    // 创建单链表
    struct Node *node =   constructNodeList();
    printNodeList(node);
    printf("=====================\n");
    // 反转单链表
    struct Node *newNode = reverseNodeList(node);
    printNodeList(newNode);
}

- (void)mergeSortedArray {
    //创建两个有序数组
    int a[5] = {1,4,6,7,9};
    int b[8] = {2,3,5,6,8,10,11,12};
    // 存储合并后的数组
    int result[13];
    // 执行合并操作
    mergeSortedArray(a, 5, b, 8, result);
    // 打印合并结果
    printf("merge result is ");
    for (int i = 0; i < 13; i ++) {
        printf("%d ",result[i]);
    }
}

- (void)findFirstChar {
    char cha[] = "acedssaddaaddf";
    char fc = findFirstChar(cha);
    printf("\nthis char is %c\n",fc);
    
    char cha1[] = "loveleetcode";
    int num = firstUniqChar(cha1);
    NSLog(@"%@",@(num));
    
}

- (void)findCommonView {
    SKFindCommonView *find = [[SKFindCommonView alloc]init];
    NSArray *viewArray =   [find findCommonSuperView:self.view1 other:self.view2];
    if (viewArray.count == 0) {
        NSLog(@"no common superview");
        return;
    }
    NSLog(@"公共视图总数为：%@",@(viewArray.count));
}

- (void)findMiddleCount {
    int list[9] = {12,3,10,8,6,7,11,13,9};
    int middle = findMiddleCount(list, 9);
    printf("\n middle is %d\n",middle);
}

- (void)swapTwoNumber {
    SKSwapTwoNumber *swap = [[SKSwapTwoNumber alloc]init];
    NSLog(@"temp = %@",[swap swapTempTwoNumber:100 number2:200]);
    NSLog(@"add = %@",[swap swapAddTwoNumber:100 number2:200]);
    NSLog(@"xor = %@",[swap swapXorTwoNumber:100 number2:200]);
}
 

- (void)arrayFindNum {
    SKArrayFindNum *num = [[SKArrayFindNum alloc]init];
    
}
@end
