//
//  SKAlogrithmVCInterview.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/11/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKAlogrithmVCInterview.h"
#import "SKCharReverse.h"

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
    [self charReverse];
}

- (void)setupLayout {
    
}


- (void)charReverse {
    char ch[] = "hello,world";
    charReverse(ch);
    printf("reverse result is %s \n",ch);
}

@end
