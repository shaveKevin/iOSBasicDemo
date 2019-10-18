//
//  DownLoadManager.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/10.
//  Copyright © 2019 小风. All rights reserved.
//

#import "DownLoadManager.h"

@implementation DownLoadManager

-(void)downLoadWithUrl:(NSString *)URL paramers:(NSDictionary *)paramers handler:(DownloadHandle)handle {
    // block 作为回调
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSession *session = [NSURLSession sharedSession];
    // 创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (handle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handle(data,error);
            });
        }
    }];
    // 启动任务
    [task resume];

    // 下载任务
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    // 启动任务
    [downloadTask resume];
    
}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    //  download
}

@end
