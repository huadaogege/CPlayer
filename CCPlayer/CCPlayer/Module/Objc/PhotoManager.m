//
//  PhotoManager.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/1.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>
#import "CCPlayer-Swift.h"
#import "PlayModel.h"
#import <UIKit/UIKit.h>

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
            AVURLAsset *urlAsset = (AVURLAsset*)asset;
            PlayModel *model = [[PlayModel alloc] init];
            model.path = urlAsset.URL.path;
            model.name = model.path.lastPathComponent;
            NSNumber *size;
            [urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
            long fileSize = size.longValue;
            NSString *fsize = @"";
            if (fileSize/(1000*1000*1000) >= 1) {
                fsize = [NSString stringWithFormat:@"%.2ldGB", fileSize/(1000*1000*1000)];
            } else if (fileSize/(1000*1000) >= 1) {
                fsize = [NSString stringWithFormat:@"%.2fMB", fileSize/(1000*1000.0)];
            } else {
                fsize = [NSString stringWithFormat:@"%.2ldKB", fileSize/1000];
            }
            CMTime time = [asset duration];
            int seconds = ceil(time.value/time.timescale);
            model.time = [NSString stringWithFormat:@"%02d:%02d:%02d", (seconds/3600), (seconds%3600)/60, seconds%60];
            model.size = fsize;
            
            AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            gen.appliesPreferredTrackTransform = YES;
            CMTime t = CMTimeMakeWithSeconds(0.0, 600);
            NSError *error = nil;
            CMTime actualTime;
            CGImageRef image = [gen copyCGImageAtTime:t actualTime:&actualTime error:&error];
            UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
            model.icon = thumb;
            
            NSArray *array = asset.tracks;
            CGSize videoSize = CGSizeZero;
            for (AVAssetTrack *track in array) {
                if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                    videoSize = track.naturalSize;
//                    break;
                }
            }
            model.bounds = videoSize;
            
            [videoModels addObject:model];
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
