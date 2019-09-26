
//
//  SKDelegateVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKDelegateVC.h"
#import "SKDelegateProtocal.h"

@interface SKDelegateVC ()<SKDelegateProtocal>

@property (nonatomic, assign) id<SKDelegateProtocal>  delegate;

@end

@implementation SKDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.delegate.nameProperty = @"9999";
}

- (void)testControl {
    NSLog(@"test");
}
@synthesize nameProperty;

@end
