//
//  TJDownloadTask.m
//  workspace
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 360tianji. All rights reserved.
//

#import "TJDownloadTask.h"
#import "WebBroswerManager.h"
#import "AFNetworking.h"

@interface TJDownloadTask ()

@property (nonatomic, strong) DownloadModel *model;
@property (nonatomic, copy) TaskDownloadProgressBlock downloadProgress;
@property (nonatomic, copy) TaskDownloadFinishedBlock downloadFinishBlock;

@end

@implementation TJDownloadTask

- (instancetype)initDownloadTaskWithModel:(DownloadModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.createTimeStamp = model.createTimeStamp;
    }
    return self;
}

- (void)startDownload {
    NSURL *URL = [NSURL URLWithString:self.model.downloadUrlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度:%f", downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount);
        if (self.downloadProgress) {
            self.downloadProgress(downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *filePath = [DocumentPath stringByAppendingPathComponent:self.model.fileName];
        [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
        if (self.downloadFinishBlock) {
            NSString *filePath = [DocumentPath stringByAppendingPathComponent:self.model.fileName];
            self.downloadFinishBlock(YES, @"下载完成", filePath);
        }
    }];
    [task resume];
}

- (void)downLoadProgress:(TaskDownloadProgressBlock)downloadProgress {
    self.downloadProgress = downloadProgress;
}

- (void)downloadFinish:(TaskDownloadFinishedBlock)downloadFinishBlock {
    self.downloadFinishBlock = downloadFinishBlock;
}


@end
