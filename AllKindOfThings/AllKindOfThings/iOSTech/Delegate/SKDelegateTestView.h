//
//  SKDelegateTestView.h
//  AllKindOfThings
//
//  Created by shavekevin on 2019/10/17.
//  Copyright © 2019 小风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SKDelegateObjectProtocal <NSObject>


- (void)testDelegateObjcControl;

@end

@interface SKDelegateTestView : UIView

@property (nonatomic, weak) id<SKDelegateObjectProtocal>  delegate;


@end

NS_ASSUME_NONNULL_END
