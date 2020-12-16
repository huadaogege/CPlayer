//
//  WebBroswerManager.h
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/18.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"
#import "TJDownloadTask.h"

NS_ASSUME_NONNULL_BEGIN



@interface WebBroswerManager : NSObject

+ (WebBroswerManager *)shareInstance;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableArray <DownloadModel *> *downloadingModels;
@property (nonatomic, strong) NSMutableArray <DownloadModel *> *downloadedModels;

@property (nonatomic, strong) NSMutableArray <TJDownloadTask *> *downloadTasks;

/**
 加入到下载任务中并开始下载

 @param model 新增下载任务
 */
- (void)addDownloadTask:(DownloadModel *)model;


/**
 删除已下载完成的记录

 @param model 下载完成的任务模型
 */
- (void)deleteDownloadedModel:(DownloadModel *)model;

@end

NS_ASSUME_NONNULL_END
