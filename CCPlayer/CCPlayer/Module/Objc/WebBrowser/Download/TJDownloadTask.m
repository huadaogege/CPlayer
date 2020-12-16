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
//    [[TJNetworkManager shareInstance] simpleDownloadFile:self.model.downloadUrlString progress:^(CGFloat progress, CGFloat total, CGFloat current) {
//        if (self.downloadProgress) {
//            self.downloadProgress(progress);
//        }
//    } complete:^(BOOL state, NSString * _Nonnull message, NSString * _Nonnull filePath) {
//        if (state) {
//            if (self.downloadFinishBlock) {
//                self.downloadFinishBlock(state, message, filePath);
//            } else {
//                NSString * path = DocumentPath;
//                NSString *fileName = self.model.fileName;
//                NSString *desFilePath = [path stringByAppendingPathComponent:fileName];
//                /* 文件下载完成之后, 调用文件管理器的存储方法 */
//                NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
//                if (fileData) {
//                    [fileData writeToFile:desFilePath atomically:YES];
//                }
//                [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
//                [[WebBroswerManager shareInstance].downloadTasks removeObject:self];
//                self.model.filePath = fileName;//存储文件名, 路径临时拼接
//                self.model.status = DownloadFinished;
//            }
//        } else {
//            [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
//            [[WebBroswerManager shareInstance].downloadTasks removeObject:self];
//        }
//    }];
    NSURL *URL = [NSURL URLWithString:self.model.downloadUrlString];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (self.downloadProgress) {
            NSLog(@"下载进度:%f", downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount);
            self.downloadProgress(downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *filePath = [DocumentPath stringByAppendingPathComponent:self.model.fileName];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
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
