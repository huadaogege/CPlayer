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
 将已下载完成的任务加入已下载队列

 @param model 下载完成的任务
 */
- (void)addDownloadedModels:(DownloadModel *)model;



@end

NS_ASSUME_NONNULL_END
