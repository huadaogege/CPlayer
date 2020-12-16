//
//  BrowserWebView.h
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/17.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroswerSearchBar.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BrowserWebViewDelegate <NSObject>
@required
- (void)loadFinished;

@end

@interface BrowserWebView : UIView

@property (nonatomic, strong) BroswerSearchBar *searchBar;
@property (nonatomic, strong) NSString *currentTitle;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL homePage;//是否显示搜索控件即是否是主页

@property (nonatomic, assign, nullable) id <BrowserWebViewDelegate> delegate;

- (void)refresh;

- (void)releaseObjc;

@end

NS_ASSUME_NONNULL_END
