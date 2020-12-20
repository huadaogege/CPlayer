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

- (void)params1:(NSString *)p1 params2:(NSString *)p2;

- (BOOL)application1:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (BOOL)application2:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;

- (void)application3:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void (^)(BOOL))completionHandler;

@end

NS_ASSUME_NONNULL_END
