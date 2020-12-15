//
//  TJDownloadTask.m
//  workspace
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 360tianji. All rights reserved.
//

#import "TJDownloadTask.h"
#import "TJNetworkManager.h"
#import "WebBroswerManager.h"

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
    [[TJNetworkManager shareInstance] simpleDownloadFile:self.model.downloadUrlString progress:^(CGFloat progress, CGFloat total, CGFloat current) {
        if (self.downloadProgress) {
            self.downloadProgress(progress);
        }
    } complete:^(BOOL state, NSString * _Nonnull message, NSString * _Nonnull filePath) {
        if (state) {
            if (self.downloadFinishBlock) {
                self.downloadFinishBlock(state, message, filePath);
            } else {
                NSString * path = [TJFileManager getBaseDir];
                path = [path stringByAppendingPathComponent:WebDir];
                [TJFileManager creatDirectoryWithPath:path];
                NSString *fileName = self.model.fileName;
                NSString *desFilePath = [path stringByAppendingPathComponent:fileName];
                /* 文件下载完成之后, 调用文件管理器的存储方法 */
                NSData *fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
                if (fileData) {
                    BOOL ret = [TJFileManager fileManagerwriteToFile:desFilePath withData:fileData];
                    NSLog(@"下载结果:%d", ret);
                }
                [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
                [[WebBroswerManager shareInstance].downloadTasks removeObject:self];
                self.model.filePath = fileName;//存储文件名, 路径临时拼接
                self.model.status = DownloadFinished;
                [[WebBroswerManager shareInstance] addDownloadedModels:self.model];
            }
        } else {
            [[WebBroswerManager shareInstance].downloadingModels removeObject:self.model];
            [[WebBroswerManager shareInstance].downloadTasks removeObject:self];
            if ([[UIViewController topViewController] isKindOfClass:[TJWebBroswerController class]] || [[UIViewController topViewController] isKindOfClass:[WebViewController class]]) {
                [MBProgressHUD showError:@"文件下载失败"];
            }
        }
    }];
}

- (void)downLoadProgress:(TaskDownloadProgressBlock)downloadProgress {
    self.downloadProgress = downloadProgress;
}

- (void)downloadFinish:(TaskDownloadFinishedBlock)downloadFinishBlock {
    self.downloadFinishBlock = downloadFinishBlock;
}

@end
