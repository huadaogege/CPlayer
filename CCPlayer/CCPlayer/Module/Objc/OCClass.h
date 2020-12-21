//
//  OCClass.h
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/1.
//

#import <Foundation/Foundation.h>
#import <SSLiveSDK/SSLiveSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClass : NSObject

+ (OCClass *)shareInstance;

- (NSString *)memoryFree;


@end

NS_ASSUME_NONNULL_END
