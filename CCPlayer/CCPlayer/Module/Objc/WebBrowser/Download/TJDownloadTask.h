//
//  TJDownloadTask.h
//  workspace
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 360tianji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TaskDownloadProgressBlock)(CGFloat downloadProgress);

typedef void(^TaskDownloadFinishedBlock)(BOOL state, NSString * _Nonnull message, NSString * _Nonnull filePath);

@interface TJDownloadTask : NSObject

@property (nonatomic, strong) NSString *createTimeStamp;//model创建时间戳作为model的唯一标示

- (instancetype)initDownloadTaskWithModel:(DownloadModel *)model;

- (void)startDownload;

- (void)downLoadProgress:(TaskDownloadProgressBlock)downloadProgress;

- (void)downloadFinish:(TaskDownloadFinishedBlock)downloadFinishBlock;

@end

NS_ASSUME_NONNULL_END
