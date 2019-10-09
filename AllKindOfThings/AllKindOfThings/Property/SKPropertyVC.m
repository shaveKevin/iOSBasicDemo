//
//  SKPropertyVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKPropertyVC.h"
#import <Masonry/Masonry.h>
#import "SKPropertyTestModel.h"

@interface SKPropertyVC ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *extLabel;
 
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UILabel *textsynLabel;

@property (nonatomic, strong) UILabel *extSynLabel;

@end

@implementation SKPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    [self normalMethod];
    [self nssetMethod];
    [self testSynthesizeAndDynamic];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.extLabel];
    [self.mainScrollView addSubview:self.textLabel];
    [self.mainScrollView addSubview:self.extSynLabel];
    [self.mainScrollView addSubview:self.textsynLabel];

    
}

- (void)setupData {
    
    self.extLabel.text = @"深拷贝&浅拷贝";
    self.textLabel.text = @"  非集合对象\n\n1. [不可变对象 copy]  --浅复制 --- 地址不变,\n\n2.[不可变对象 mutableCopy]  --深复制 --地址发生变化,\n\n3.[可变对象 copy] -- 深复制  -- 地址发生变化，\n\n4.[可变对象 mutableCopy] --深复制 --地址发生变化。\n\n浅拷贝的时候 更改原值 才可能会影响新值。深拷贝相当于直接开辟一个空间copy出来一个副本 除了值没变 其他都变了。\n\n 集合对象\n\n1.[不可变对象 copy]   浅复制 因为地址没变\n\n2. [不可变对象  mutableCopy] 深复制 因为地址变了 但是里面的元素地址并没有改变 说明这是复制只是单层深复制,也就是说集合对象的深拷贝只是单层的深拷贝。集合元素并没有被深拷贝到\n\n3.[可变对象  copy] 单层深复制\n\n4. [不可变对象 mutableCopy] 单层深复制,值不变，对象地址发生改变。\n\n深拷贝的时候 对原对象做操作不会影响拷贝对象的行为，但是如果对里面元素做操作 可能会受影响。因为集合中的元素并未被拷贝到。\n\n总结来说，复制有三种：\n\n1.浅复制(shallow copy)：在浅复制操作时，对于被复制对象的每一层都是指针复制。\n\n2.深复制(one-level-deep copy)：在深复制操作时，对于被复制对象，至少有一层是深复制。\n\n3.完全复制(real-deep copy)：在完全复制操作时，对于被复制对象的每一层都是对象复制。";
    self.extSynLabel.text = @"@synthesize和@dynamic分别有什么作用?";
    self.textsynLabel.text = @" 1. @proprerty 有两个对应的词，一个是@synthesize一个是@sdynamic，如果@synthesize和@dynamic都没写。那么默认的就是@synthesize  var = _var;\n\n2. @synthesize 的语义是如果你没有手动实现setter 和 getter 方法。那么编译器会自动为你加上这两个方法。\n\n3. @dynamic 告诉编译器，setter和getter方法由用户自己实现，不自动生成。(对于readonly的属性只需要提供getter即可)假如一个属性被声明为@dynamic var 如果你没有实现setter 和getter方法，虽然编译的时候不会报错，但是当程序运行到 instance.var = someVar 的时候，由于缺少setter方法 而crash 报错信息为:（-[SKPropertyTestModel setTitle:]: unrecognized selector sent to instance 0x2803a51a0） 当运行到someVar= var的时候。由于缺少getter 方法而crash.报错信息为:（ -[SKPropertyTestModel title]: unrecognized selector sent to instance 0x2829a0160）在编译的时候没问题，在运行的时候才会去执行对应的方法，这就是所谓的动态绑定。";
}

- (void)setupLayout {
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.topMargin.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    [self.extLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.extLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.bottom.mas_equalTo(-15);
    }];
    
    [self.extSynLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.textLabel.mas_bottom).offset(15);
    }];
    [self.textsynLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.extSynLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-15);
    }];
}



// 非集合类

- (void)normalMethod {
    // 以下的地址指的是对象本身的地址。。。并不是对象指针的地址。
    //1. 使用copy
    NSMutableString *string = [NSMutableString stringWithString:@"origin"];//copy
    NSString *stringCopy = [string copy];
    // 通过打印可以看到这里使用了copy 此时的stringCopy地址发生了改变，只是值的copy 这种copy是内容拷贝 是深拷贝。
    // 这个时候即使对string做其他操作 stringcCopy的值也不会改变。
    NSLog(@"string  is %@   &  stringcopy  is %@",string,stringCopy);
    NSLog(@"string address is %p   &  stringcopy address is %p",string,stringCopy);
    [string appendString:@"哈哈哈"];
    NSLog(@"  new string  is %@   &  new stringcopy  is %@",string,stringCopy);
    NSLog(@"=================分割线=================");
    // 2.不使用copy
    NSMutableString *stringNotCopy = [NSMutableString stringWithString:@"stringNotCopy"];//copy
    NSString *stringNot = stringNotCopy;
    // 通过打印可以看到这里没用使用copy 此时的stringCopy地址发生了改变，只是值的copy 这种copy是内容拷贝 是深拷贝。
    // 这个时候即使对stringNotCopy做其他操作 stringNot的值也会改变。因为
    NSLog(@"stringNot  is %@   &  stringNotCopy  is %@",stringNot,stringNotCopy);
    NSLog(@"stringNot address is %p   &  stringNotCopy address is %p",stringNot,stringNotCopy);
    [stringNotCopy appendString:@"哈哈哈"];
    NSLog(@"  new stringNot  is %@   &  new stringNotCopy  is %@",stringNot,stringNotCopy);
    // 这里能解决一个面试题： 为什么用property声明NSString  NSArray NSDictionary 经常使用关键字copy?
    // 答:因为他们有对应的可变类型NSMutableString NSMutableArray  NSMutableDictionary 他们之间可能进行赋值操作。为了确保对象中的字符串数值不会无意间变动，应该在设置新值的时候copy一份。
   //简单总结一下：
   // 1. [不可变对象 copy]  --浅复制 --- 地址不变
  // 2.[不可变对象 mutableCopy]  --深复制 --地址发生变化
    NSString *immutableString = @"拷贝";
    NSString *commtableString = [immutableString copy];
    NSString *mutableString = [immutableString mutableCopy];
    immutableString = [immutableString stringByAppendingString:@"===哈哈=="];
    NSLog(@"immutableString value is %@   &  copy之后 value is %@  & mutableCopy 之后value is  %@",immutableString,commtableString,mutableString);

    NSLog(@"不可变字符串 address is %p   &  copy之后地址 is %p  & mutableCopy 之后地址is  %p",immutableString,commtableString,mutableString);
    // 3.[可变对象 copy] -- 深复制  -- 地址发生变化
    // 4.[可变对象 mutableCopy] --深复制 --地址发生变化
    NSMutableString *mutableStringCopy = [[NSMutableString alloc]initWithString:@"看啥子哦"];
    NSMutableString *mutableStringXXX = [mutableStringCopy copy];
    NSMutableString *mutableStringMutableCopy = [mutableStringCopy mutableCopy];
    [mutableStringCopy stringByAppendingString:@"====附加的字符串"];
    
    NSLog(@"mutableStringCopy value is %@   &  copy之后 value is %@  & mutableCopy 之后value is  %@",mutableStringCopy,mutableStringXXX,mutableStringMutableCopy);

    NSLog(@"可变字符串 address is %p   &  copy之后地址 is %p  & mutableCopy 之后地址is  %p",mutableStringCopy,mutableStringXXX,mutableStringMutableCopy);
// 浅拷贝的时候 更改原值 才可能会影响新值。深拷贝相当于直接开辟一个空间copy出来一个副本 除了值没变 其他都变了。

}
// 集合类

- (void)nssetMethod {
    // 集合的深复制有两种a方法实现：一 使用mutableCopy 第二种使用 copyItems
    // 1.[不可变对象 copy]   浅复制 因为地址没变
    // 2. [不可变对象  mutableCopy] 深复制 因为地址变了 但是里面的元素地址并没有改变 说明这是复制只是单层深复制
    //  也就是说集合对象的深拷贝只是单层的深拷贝。集合元素并没有被深拷贝到
    NSArray *dataArray = @[@1,@2,@3];
    NSArray *dataArrayCopy = [dataArray copy];
    NSMutableArray *dataArrayMutableCopy = [dataArray mutableCopy];
    NSLog(@"dataArray value is %@, dataArrayCopy  value is %@, dataArrayMutableArrayCopy is %@ ",dataArray, dataArrayCopy,dataArrayMutableCopy);
    
    NSLog(@"dataArray address is %p, dataArrayCopy  address is %p, dataArrayMutableArrayCopy   address is %p ",dataArray, dataArrayCopy,dataArrayMutableCopy);
    NSLog(@"dataArray  首地址  is %p, dataArrayCopy  首地址 is %p, dataArrayMutableArrayCopy   首地址 is %p ",dataArray[0],dataArrayCopy[0],dataArrayMutableCopy[0]);
    
    NSMutableArray *deepCopyArray = [[NSMutableArray alloc]initWithArray:dataArray copyItems:YES];
    NSLog(@"deepCopyArray  is ====%@,  deepCopyArray  address is %p",deepCopyArray,deepCopyArray[0]);
    
    // 3.[可变对象  copy] 单层深复制
    // 4. [不可变对象 mutableCopy] 单层深复制
    // 值不变，对象地址发生改变。
    NSMutableArray *array  = dataArray.mutableCopy;
    NSMutableArray *arrayCopy = [array copy];
    NSMutableArray *arrayMutableCopy = [array mutableCopy];
    NSLog(@"array value is %@, arrayCopy  value is %@, arrayMutableCopy value  is %@ ",array, arrayCopy,arrayMutableCopy);
    NSLog(@"array address is %p, arrayCopy  address is %p, arrayMutableCopy   address is %p ",array, arrayCopy,arrayMutableCopy);
    NSLog(@"array  首地址  is %p, arrayCopy  首地址 is %p, arrayMutableCopy   首地址 is %p ",array[0],arrayCopy[0],arrayMutableCopy[0]);
    
    
}

- (void)testSynthesizeAndDynamic {
    SKPropertyTestModel *model = [[SKPropertyTestModel alloc]init];
    model.title =  @"title";
    NSLog(@"%@",model.title);
    
    [model takeActions];
}

- (UILabel *)textLabel {
    if (!_textLabel ) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.numberOfLines = 0;
        _textLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 30;
    }
    return _textLabel;
}

- (UILabel *)extLabel {
    if (!_extLabel ) {
        _extLabel = [[UILabel alloc]init];
        _extLabel.textColor = [UIColor blackColor];
        _extLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _extLabel;
}
- (UILabel *)extSynLabel {
    if (!_extSynLabel ) {
           _extSynLabel = [[UILabel alloc]init];
           _extSynLabel.textColor = [UIColor blackColor];
           _extSynLabel.textAlignment = NSTextAlignmentCenter;
       }
       return _extSynLabel;
}

-(UILabel *)textsynLabel {
    if (!_textsynLabel ) {
          _textsynLabel = [[UILabel alloc]init];
          _textsynLabel.textColor = [UIColor blackColor];
          _textsynLabel.numberOfLines = 0;
          _textsynLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 30;
      }
    return _textsynLabel;
}
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];
    }
    return _mainScrollView;
}
@end
