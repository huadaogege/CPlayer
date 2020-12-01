//
//  PhotoManager.h
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@class PlayModel;

@interface PhotoManager : NSObject

+ (void)videoInfoOfsystem:(void(^)(NSArray *))block;

@end

NS_ASSUME_NONNULL_END
