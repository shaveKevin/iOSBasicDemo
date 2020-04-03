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
    // 当分类和原类都有相同的方法的时候，优先执行原类方法
    SKCategoryObj *obj = [SKCategoryObj new];
//    [obj testCategoryObjMethod];

    u_int count = 0;
    Method *methods = class_copyMethodList([obj class], &count);
    NSInteger index = 0;
    for (int i = count - 1; i >0; i--) {
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

//面试题：分类和延展有什么区别？
/*
 答：生成的文件不同
 新建Category会生成 .h 和 .m 两个文件，而新建Extension仅生成一个 .h 文件。
 Category不能添加类属性，而Extension添加私有属性或变量。
 Category添加的方法会被子类继承，而Extension添加的方法、属性不能被子类继承（因为它们是private的）。
 Category可以为自定义的类或者framework框架中的类增加方法，而Extension只能为自定义的类添加方法（因为OC是闭源的，系统的 .m 方法不可见）
 Category是@interface 本类名 (分类名)、@implementation 本类名(分类名)，而Extension是 @interface 本类名 ()。
 分类中在 .h 中声明、在 .m 中实现的方法为公开方法，可被外部访问；Extension中的方法为私有方法、变量为私有变量，外界无法直接访问。
 （OC中因为没有真正意义上的私有方法，所以可以通过选择器访问）。
 （PS：如果公开方法、私有方法声明的方法名相同，经测试只要实现了该方法就是公开方法）。
 可以把Extension理解为特殊的Category。

 参考资料：https://www.jianshu.com/p/b30f7f0ef77c
 
 */
