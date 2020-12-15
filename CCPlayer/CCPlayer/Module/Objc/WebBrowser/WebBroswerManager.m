//
//  WebBroswerManager.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/18.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "WebBroswerManager.h"
#import "TJDBTableStruct.h"
#import "TJFMDBUserManager.h"
#import "CustomAlertVC.h"
#import "TJNetworkStateManager.h"

#define Support_Download_ContentType [NSDictionary dictionaryWithObjectsAndKeys:@".cer", @"application/x-cel",\
@".jpeg", @"image/jpeg",\
@".mp3", @"video/mpeg",\
@".pdf", @"application/pdf",\
@".pdf", @"application/pdf;charset=UTF-8",\
@".png", @"application/x-plt",\
@".doc", @"application/msword",\
@".jpg", @"application/x-jpg",\
@".mp4", @"video/mpeg4",\
@"mpeg", @"video/mpg",\
@".png", @"application/x-png",\
@".ppt", @"application/x-ppt",\
@".wav", @"audio/wav",\
@".xls", @"application/x-xls",\
@".avi", @"video/avi",\
@".mp3", @"audio/mp3",\
@".png", @"image/png",\
@".ppt", @"application/vnd.ms-powerpoint",\
@".txt", @"text/plain",\
@".xls", @"application/vnd.ms-excel",\
@".zip", @"application/zip",\
nil]

#define Support_Download_File_Type [NSArray arrayWithObjects:@"jpeg", @"png", @"doc", @"docx", @"ppt", @"pptx",\
@"xls", @"xlsx", @"mp3", @"mp4", @"mov", @"pdf", @"txt", @"m4v", @"avi", @"aac", @"aiff", @"wav", @"zip", @"rar", nil]

@interface WebBroswerManager ()

@end
 
static WebBroswerManager *instance;

@implementation WebBroswerManager

+ (WebBroswerManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WebBroswerManager alloc] init];
    });
    return instance;
}

#pragma mark -- 初始化 --

- (NSMutableArray<DownloadModel *> *)downloadingModels {
    if (!_downloadingModels) {
        _downloadingModels = [[NSMutableArray alloc] init];
    }
    return _downloadingModels;
}

- (NSMutableArray<DownloadModel *> *)downloadedModels {
    if (!_downloadedModels) {
        _downloadedModels = [[NSMutableArray alloc] init];
    }
    return _downloadedModels;
}

- (NSMutableArray<TJDownloadTask *> *)downloadTasks {
    if (!_downloadTasks) {
        _downloadTasks = [[NSMutableArray alloc] init];
    }
    return _downloadTasks;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
    }
    return _dateFormatter;
}

#pragma mark -- 下载管理 --

- (BOOL)isDownloadUrlWithHeaderInfo:(NSDictionary *)headerInfo urlString:(NSString *)urlString {
    NSString *contentType = headerInfo[@"Content-Type"];
    NSString *disposition = headerInfo[@"Content-Disposition"];
    NSString *sufString = [disposition  componentsSeparatedByString:@"."].lastObject.lowercaseString;
    NSString *extensionName = urlString.lastPathComponent.pathExtension.lowercaseString;
    if ([Support_Download_ContentType objectForKey:contentType] ||
        [Support_Download_File_Type containsObject:extensionName] ||
        [Support_Download_File_Type containsObject:sufString]) {
        NSLog(@"下载地址:%@", urlString);
        NSString *createTimeStamp = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]*1000];
        NSString *fileName = [self getDownloadFileName:headerInfo];
        if (fileName.length == 0) {
            fileName = createTimeStamp;
            if (![Support_Download_ContentType objectForKey:contentType]) {
                fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@", extensionName]];
            } else {
                fileName = [fileName stringByAppendingString:[Support_Download_ContentType objectForKey:contentType]];
            }
        }
        fileName = [NSString stringWithFormat:@"%@_%@",createTimeStamp,fileName];
        fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@", extensionName]];
        if(!extensionName || extensionName.length>6){
             fileName = [fileName stringByAppendingString:[Support_Download_ContentType objectForKey:contentType]];
        }
        DownloadModel *model = [[DownloadModel alloc] init];
        model.downloadUrlString = urlString;
        model.fileName = fileName;
        model.status = Downloading;
        model.createTimeStamp = createTimeStamp;
        BOOL wifi = [[TJNetworkStateManager shareInstance] hasWIFI];
        NSString *netTips = wifi ? @"" : @"当前是移动网络，";
        NSString *message = [NSString stringWithFormat:@"%@确定下载文件'%@'", netTips, fileName];
        UIAlertController *alertController = [CustomAlertVC alertWithTitle:@"提示" message:message letfTitle:@"取消" rightTitle:@"确定" clickCallBack:^(NSInteger index) {
            if (index == 1) {
                if (self.downloadTasks.count >= 4) {
                    [MBProgressHUD showError:@"已达到最大下载数量,请稍后添加"];
                } else {
                    [self addDownloadTask:model];
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"文件:%@已加入下载队列", model.fileName]];
                }
            }
        }];
        [[UIViewController topViewController] presentViewController:alertController animated:YES completion:^{
        }];
        return YES;
    }
    /* 该类型为二进制流类型, 即使不支持下载, 也不允许跳转 */
    if ([contentType isEqualToString:@"application/octet-stream"]) {
        return YES;
    }
    return NO;
}

/**
 获取下载文件的文件名

 @param headerInfo 下载文件头信息
 @return 文件真实名字
 */
- (NSString *)getDownloadFileName:(NSDictionary *)headerInfo {
    NSString *contentDisposition = headerInfo[@"Content-Disposition"];
    contentDisposition = [contentDisposition stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *keysArray = [contentDisposition componentsSeparatedByString:@";"];
    NSString *fileName = @"";
    for (NSString *key in keysArray) {
        if ([key hasPrefix:@"filename"]) {
            fileName = key;
            break;
        }
    }
    NSArray *fileNameArray = [fileName componentsSeparatedByString:@"="];
    if (fileNameArray.count > 1) {
        fileName = fileNameArray[1];
    }
    fileName = [fileName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return fileName;
}

/**
 加入到下载任务中并开始下载

 @param model 新增下载任务
 */
- (void)addDownloadTask:(DownloadModel *)model {
    [self.downloadingModels addObject:model];
    TJDownloadTask *task = [[TJDownloadTask alloc] initDownloadTaskWithModel:model];
    [self.downloadTasks addObject:task];
    [task startDownload];
}

- (NSDictionary *)downloadedInfoFromModel:(DownloadModel *)model {
    return @{@"fileName":model.fileName == nil ? @"":model.fileName,
             @"downloadUrlString":model.downloadUrlString == nil ? @"":model.downloadUrlString,
             @"filePath":model.filePath == nil ? @"":model.filePath,
             @"createTimeStamp":model.createTimeStamp == nil ? @"":model.createTimeStamp,
             @"status":@(model.status)
             };
}

/**
 将下载完成的任务加入到已下载队列, 并存入数据库

 @param model 已下载完成模型
 */
- (void)addDownloadedModels:(DownloadModel *)model {
    [self.downloadedModels addObject:model];
}


@end
