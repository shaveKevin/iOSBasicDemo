//
//  SKTraggedPointSubClass.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/4.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTaggedPointSubClass.h"

@implementation SKTaggedPointSubClass
+(void)load {
    NSLog(@"子类的load");
}

+(void)initialize {
    NSLog(@"子类的initialize");

}
- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}
@end
