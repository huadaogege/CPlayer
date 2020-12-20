//
//  WebBroswerManager.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/18.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "WebBroswerManager.h"
//#import "TJNetworkStateManager.h"

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

/**
 删除已下载完成的记录

 @param model 下载完成的任务模型
 */
- (void)deleteDownloadedModel:(DownloadModel *)model {
    
}

- (NSDictionary *)downloadedInfoFromModel:(DownloadModel *)model {
    return @{@"fileName":model.fileName == nil ? @"":model.fileName,
             @"downloadUrlString":model.downloadUrlString == nil ? @"":model.downloadUrlString,
             @"filePath":model.filePath == nil ? @"":model.filePath,
             @"createTimeStamp":model.createTimeStamp == nil ? @"":model.createTimeStamp,
             @"status":@(model.status)
             };
}



@end
