//
//  SKDelegateTestView.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import <UIKit/UIKit.h>
// 面试题：代理为什么要声明成weak 而不是strong和assign？

NS_ASSUME_NONNULL_BEGIN
@protocol SKDelegateObjectProtocal <NSObject>


- (void)testDelegateObjcControl;

@end

@interface SKDelegateTestView : UIView
// 注意这里要定义为weak  如果用strong 会产生循环引用
@property (nonatomic, weak) id<SKDelegateObjectProtocal>  delegate;

@end

NS_ASSUME_NONNULL_END
