//
//  PhotoManager.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/1.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>
#import "CCPlayer-Swift.h"

@implementation PhotoManager

+ (void)videoInfoOfsystem:(void(^)(NSArray *))block {
    NSMutableArray *videoAssets = [[NSMutableArray alloc] init];
    NSMutableArray *videoModels = [[NSMutableArray alloc] init];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    [assetsFetchResults enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            [videoAssets addObject:asset];
        }
        
    }];
    for (PHAsset *asset in videoAssets) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            NSLog(@"");
            PlayModel *model = [[PlayModel alloc] init];
            
            [videoModels addObject:info];
            if (videoModels.count == videoAssets.count) {
                if (block) {
                    block(videoModels);
                }
            }
        }];
    }
    
    
    NSLog(@"assets:%@", videoAssets);
}


@end
