//
//  DownLoadManager.h
//  TestBlock
//
//  Created by shavekevin on 2019/9/10.
//  Copyright © 2019 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DownloadHandle)(NSData * receiveData, NSError *error);

@interface DownLoadManager : NSObject<NSURLSessionDownloadDelegate>

- (void)downLoadWithUrl:(NSString *)URL paramers:(NSDictionary *)paramers handler:(DownloadHandle)handle;


@end

NS_ASSUME_NONNULL_END
