//
//  DownloadModel.h
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/22.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DownloadStatus) {
    Downloading = 0,//下载中
    DownloadFinished//已下载
};

@interface DownloadModel : NSObject

@property (nonatomic, assign) DownloadStatus status;//文件状态
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *downloadUrlString;//文件下载链接
@property (nonatomic, assign) long int fileLength;//文件大小
@property (nonatomic, strong) NSString *filePath;//下载完成之后的文件路径
@property (nonatomic, strong) NSString *createTimeStamp;//model创建时间戳作为model的唯一标示

@end

NS_ASSUME_NONNULL_END
