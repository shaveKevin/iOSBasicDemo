//
//  SKPropertyTestModel.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKPropertyTestModel.h"

@interface SKPropertyTestModel ()

@property (nonatomic, copy,readonly) NSString *propertyTestString;

@property (nonatomic,readwrite, strong) NSArray *dataArray;

@property (nonatomic, strong) NSString *strongString;

@property (nonatomic, copy) NSString *copString;



@end

@implementation SKPropertyTestModel
{
    NSString *_title;
}
//@dynamic title;
// @synthesize title = _title;
- (void)setTitle:(NSString *)title{
    _title = title;
}

- (NSString *)title {
    return _title;
}


- (void)takeActions {
    
    NSArray *arrayData = @[@1,@3,@5];
    NSMutableArray *mutableArray  = [NSMutableArray arrayWithArray:arrayData];

    self.dataArray = mutableArray;
   
    
    NSLog(@"self.dataArray is %p,mutableArray  is  %p",self.dataArray,mutableArray);
    NSLog(@"self.dataArray 首地址 is %p,mutableArray   首地址 is  %p",self.dataArray[0],mutableArray[0]);
    [mutableArray removeAllObjects];

    NSLog(@"self.dataArray is  %@",self.dataArray);
    [mutableArray addObjectsFromArray:arrayData];
    self.dataArray = [mutableArray copy];
    [mutableArray removeAllObjects];
    
    NSLog(@"self.dataArray  last  is  %@",self.dataArray);
    
    [self stringTest];

}

- (void)stringTest {
    //  用copy修饰的字符串不能够被改变，但是用strong 修饰的字符串就能被改变。容易引起其他问题。
    NSMutableString *mutableString = [[NSMutableString alloc]initWithString:@"可变字符串"];
    self.strongString = mutableString;
    self.copString = mutableString;
    NSLog(@"strongString  is  %@，copyStrings  is  %@",self.strongString,self.copString);
    [mutableString appendString:@"是可变的"];
    NSLog(@"strongString 拼接之后 is  %@，copyStrings  拼接之后  is  %@",self.strongString,self.copString);
}

// 面试题解答：用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题？
/*
 /当定义属性为copy的时候，这里做的是拷贝单层深拷贝  当属性定义为strong 的时候你会发现 self.dataArray 受到 mutableArray值的影响
 
 1.因为父类指针可以指向子类对象，使用copy的目的是为了让本对象拿到的数据不受外界的影响。
 使用copy无论传给的值是一个可变对象还是不可变对象，那么本身持有的就是一个不可变的副本。
    2.  如果使用strong，那么这个属性就可能是指向一个可变对象，如果这个可变对象在外部被修改了。那么会影响该属性。
 */

@end
