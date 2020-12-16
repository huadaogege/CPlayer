//
//  WebBrowswerController.m
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/15.
//

#import "WebBrowswerController.h"
#import "BrowserWebView.h"

@interface WebBrowswerController ()

@property (nonatomic, strong) BrowserWebView *currentWebView;//当前web视图

@end

@implementation WebBrowswerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.title = @"在线浏览";
    
    [self.view addSubview:self.currentWebView];
}

- (BrowserWebView *)currentWebView {
    if (!_currentWebView) {
        CGFloat broswerWebViewHeight = kScreenHeight - kStatusSafeAreaBottomHeight - kStatusSafeAreaTopHeight;
        _currentWebView = [[BrowserWebView alloc] initWithFrame:CGRectMake(0,
                                                                           kStatusSafeAreaTopHeight,
                                                                           kScreenWidth,
                                                                           broswerWebViewHeight)];
        _currentWebView.homePage = YES;
    }
    return _currentWebView;
}


@end
