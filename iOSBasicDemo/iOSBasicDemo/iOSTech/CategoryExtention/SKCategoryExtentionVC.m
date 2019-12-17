//
//  SKCategoryExtentionVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKCategoryExtentionVC.h"
#import "SKCategoryObj.h"
#import <objc/runtime.h>

@interface SKCategoryExtentionVC ()

@end

@implementation SKCategoryExtentionVC

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
}

- (void)setupData {
    
}

- (void)setupLayout {
    
}

- (void)privateMethod {
    SKCategoryObj *obj = [SKCategoryObj new];
//    [obj testCategoryObjMethod];

    u_int count = 0;
    Method *methods = class_copyMethodList([obj class], &count);
    NSInteger index = 0;
    for (int i = count; i >0; i--) {
        SEL name = method_getName(methods[i]);
        NSString *strName =  [NSString stringWithCString:sel_getName(name) encoding:kCFStringEncodingUTF8];
        if ([strName isEqualToString:@"testCategoryObjMethod"]) {
            index = i;
            break;
        }
    }
    SEL sel = method_getName(methods[index]);
    IMP imp = method_getImplementation(methods[index]);
    ((void(*)(id,SEL))imp)(obj,sel);
    // 还可以用
  //   ((void (*)(id,SEL))objc_msgSend)(obj, sel);


}

@end
