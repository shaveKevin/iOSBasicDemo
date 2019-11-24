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
@end
