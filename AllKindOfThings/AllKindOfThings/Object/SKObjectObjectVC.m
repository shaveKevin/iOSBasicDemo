
//
//  SKObjectObjectVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKObjectObjectVC.h"
#import "SKSubObject.h"

@interface SKObjectObjectVC ()

@end

@implementation SKObjectObjectVC

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
    SKSubObject *objc = [[SKSubObject alloc]init];
    
    SKObjectObject *obb = [[SKObjectObject alloc]init];
    [obb printObjectObject];
    [SKObjectObject thisisSuperMethod];
    NSLog(@"SKObjectObject class is ==%p",[SKObjectObject class]);
}

- (void)setupLayout {
    
}


@end
