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

@interface SKAlogrithmVCInterview ()

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
}
@end
