//
//  SLLive.h
//  SLLiveTest
//
//  Created by john on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SLLive : NSObject

+ (instancetype)sharedInstance;

/// 开启sdk,在appDelegate里调用即可
/// @param launchOptions appDelegate里的didFinishLaunchingWithOptions 传launchOptions
- (void)startSDK:(NSDictionary *)launchOptions;

/// 套壳开关请求
/// @param result 只有error为nil,说明请求才成功,switchApp状态才有效
- (void)requestAppControllSwitch:(void(^)(BOOL switchApp,NSError* __nullable error))result;
#pragma mark:------以下为appDelegate对应的方法,如果要切换,对应调用即可
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void (^)(BOOL))completionHandler;


@end

NS_ASSUME_NONNULL_END
