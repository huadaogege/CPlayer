//
//  BrowserWebView.m
//  TJBroswer
//
//  Created by 崔玉冠 on 2018/10/17.
//  Copyright © 2018 崔玉冠. All rights reserved.
//

#import "BrowserWebView.h"
#import <AssertMacros.h>
#import "BrowserLoadFailedView.h"
#import "MBProgressHUD+TJ.h"
#import "DownloadModel.h"
#import "CustomAlertVC.h"
#import "WebBroswerManager.h"

#define Support_Download_ContentType [NSDictionary dictionaryWithObjectsAndKeys:@".cer", @"application/x-cel",\
@".jpeg", @"image/jpeg",\
@".mp3", @"video/mpeg",\
@".pdf", @"application/pdf",\
@".pdf", @"application/pdf;charset=UTF-8",\
@".png", @"application/x-plt",\
@".doc", @"application/msword",\
@".jpg", @"application/x-jpg",\
@".mp4", @"video/mpeg4",\
@"mpeg", @"video/mpg",\
@".png", @"application/x-png",\
@".ppt", @"application/x-ppt",\
@".wav", @"audio/wav",\
@".xls", @"application/x-xls",\
@".avi", @"video/avi",\
@".mp3", @"audio/mp3",\
@".png", @"image/png",\
@".ppt", @"application/vnd.ms-powerpoint",\
@".txt", @"text/plain",\
@".xls", @"application/vnd.ms-excel",\
@".zip", @"application/zip",\
nil]

#define Support_Download_File_Type [NSArray arrayWithObjects:@"jpeg", @"png", @"doc", @"docx", @"ppt", @"pptx",\
@"xls", @"xlsx", @"mp3", @"mp4", @"mov", @"pdf", @"txt", @"m4v", @"avi", @"aac", @"aiff", @"wav", @"zip", @"rar", nil]

#define CollectionViewCellIdentifier  @"__BrowserWebViewCellIdentifier__"

typedef void (^webviewCompletionHandler)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential);

@interface BrowserWebView () <WKUIDelegate, WKNavigationDelegate, BroswerSearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSURLSessionTaskDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) MBProgressHUD *loadingView;
@property (nonatomic, strong) UIImageView *topBgImageView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) BrowserLoadFailedView *loadFailedView;
@property (nonatomic, strong) NSString *currentUrlString;
@property (nonatomic, assign) BOOL webViewStop;//主动停掉webView加载
@property (nonatomic, strong) UITapGestureRecognizer *tapGesturRecognizer;//点击collectionview空白处消失键盘

@property (nonatomic, assign)BOOL hiddenLoadFaileView;
@property (nonatomic,copy) webviewCompletionHandler webCompletion;
@end

@implementation BrowserWebView
static int refreshCount = 0;//标记当前界面刷新次数

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeView];
        /* 有些网页, 点击加载过程中监测不到url从开始加载到加载完成的回调,
         无法处理前进后退, 所以监听webview加载进度, 加载完成之后刷新前进后退状态 */
        [self.webView addObserver:self
                       forKeyPath:@"estimatedProgress"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:@"BrowserWebView_self"];
        // 添加通知监听见键盘弹出/退出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
        
        
    }
    return self;
}

- (void)initializeView {
    self.hiddenLoadFaileView = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.topBgImageView = [[UIImageView alloc] init];
    self.topBgImageView.image = [UIImage imageNamed:@"broswer_search"];
    [self addSubview:self.topBgImageView];

    CGFloat bgHeight = kScreenWidth*145/375;
    CGFloat bgWidth = bgHeight*1.16;
    [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(40));
        make.centerX.equalTo(self);
        make.width.equalTo(@(bgWidth));
        make.height.equalTo(@(bgHeight));
    }];
    
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBgImageView.mas_bottom).with.offset(-25);
        make.top.equalTo(self.topBgImageView.mas_bottom).with.offset(26);
        make.left.equalTo(self).with.offset(28);
        make.right.equalTo(self).with.offset(-28);
        make.height.equalTo(@(45));
    }];
    
    [self addSubview:self.webView];
    CGFloat webViewHeight = kScreenHeight - kStatusSafeAreaTopHeight - kStatusTabbarHeight;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(webViewHeight));
    }];
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.backgroundColor = [UIColor whiteColor];
    self.progressView.progress = 0;
    [self.webView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.webView);
        make.height.equalTo(@2);
    }];
    
    [self.webView addSubview:self.loadFailedView];
    [self.loadFailedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView);
    }];
    self.loadFailedView.hidden = YES;
}

- (MBProgressHUD *)loadingView {
    if (!_loadingView) {
        _loadingView = [MBProgressHUD showLoadingMessage:@"加载中..." toView:self];
    }
    return _loadingView;
}

- (BroswerSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[BroswerSearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.suppressesIncrementalRendering = YES;
        config.processPool = [[WKProcessPool alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:config];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

-(UITapGestureRecognizer *)tapGesturRecognizer{
    if (!_tapGesturRecognizer) {
         _tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTextFiledResignFirstResponder)];
        _tapGesturRecognizer.delegate = self;
    }
    return _tapGesturRecognizer;
}

- (BrowserLoadFailedView *)loadFailedView {
    if (!_loadFailedView) {
        _loadFailedView = [[BrowserLoadFailedView alloc] initWithReloadBlock:^{
            [self refresh];
        }];
    }
    return _loadFailedView;
}

- (void)setHomePage:(BOOL)homePage {
    _homePage = homePage;
    self.webView.hidden = homePage;
    self.searchBar.hidden = !homePage;
    self.progressView.hidden = homePage;
    if (homePage) {
        self.loadingView.hidden = YES;
        refreshCount = 0;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar.searchTextFiled resignFirstResponder];
}

-(void)searchTextFiledResignFirstResponder{
    [self.searchBar.searchTextFiled resignFirstResponder];
}

//解决手势冲突 collectionview的cell点击与空白点击消失键盘的冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UICollectionView"]) {
        return YES;
    }
    return NO;
}

- (void)refresh {
    if (!self.currentUrlString || _homePage==YES) {
        [MBProgressHUD showError:@"当前无可刷新页面"];
        return;
    }
   
    [self searchButtonClick:self.currentUrlString fromRecord:YES];
   
}

#pragma mark -- observeValueForKeyPath --

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    /* 有些网页, 点击加载过程中监测不到url从开始加载到加载完成的回调,
     无法处理前进后退, 所以监听webview加载进度, 加载完成之后刷新前进后退状态 */
    if ([object isEqual:self.webView] && [keyPath isEqualToString:@"estimatedProgress"]) {
        float progressValue = [change[@"new"] floatValue];
        self.progressView.hidden = NO;
        self.progressView.progress = progressValue;
        if (progressValue == 1) {
            self.progressView.progress = 0;
            self.progressView.hidden = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished)]) {
                [self.delegate loadFinished];
            }
        }
    }
}

#pragma mark -- BroswerSearchBarDelegate --

- (void)searchButtonClick:(NSString *)searchContent fromRecord:(BOOL)fromRecord {
    [self setHomePage:NO];
    searchContent = [self addPrefixToIp:searchContent];
    if ([searchContent.lowercaseString hasPrefix:@"http://"] || [searchContent.lowercaseString hasPrefix:@"https://"]) {
        if (!fromRecord) {
            searchContent = [searchContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:searchContent]]];
    } else {
        NSString *searchSo = @"https://m.baidu.com/s?word=";
        searchContent = [self urlEncodeWithString:searchContent];
        NSString *searchUrlString = [NSString stringWithFormat:@"%@%@", searchSo, searchContent];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:searchUrlString]]];
    }
}

- (NSString *)urlEncodeWithString:(NSString*)string {
    //对下载链接编码
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                     (CFStringRef)string ,
                                                                                     NULL ,
                                                                                     CFSTR("!*'();:@&=+$,/?%#[]") ,
                                                                                     kCFStringEncodingUTF8));
}

//- (void)requestByURLSession:(NSString *)urlString {
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *quest = [NSMutableURLRequest requestWithURL:url];
//    quest.HTTPMethod = @"GET";
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config
//                                                             delegate:self
//                                                        delegateQueue:[NSOperationQueue currentQueue]];
//    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:quest
//                                               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                                                   NSLog(@"%@", response);
//                                               }];
//    [task resume];
//}
//
//#pragma mark -- NSURLSessionTaskDelegate Methods --
//
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
//        willPerformHTTPRedirection:(NSHTTPURLResponse *)response
//                        newRequest:(NSURLRequest *)request
//                 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
//    if (response.statusCode == 301 || response.statusCode == 302) {
//        [self.webView loadRequest:request];
//    }
//    completionHandler(request);
//}

/**
 对裸IP增加http前缀

 @param string 裸IP
 @return 增加http前缀之后的地址
 */
- (NSString *)addPrefixToIp:(NSString *)string {
    NSArray *ipArray = [string componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        for (NSString *ipNumber in ipArray) {
            int number = [ipNumber intValue];
            if (!(number >= 0 && number <= 255)) {
                return string;
            }
        }
        if (![string hasPrefix:@"http://"] && ![string hasPrefix:@"https://"]) {
            return [NSString stringWithFormat:@"http://%@", string];
        }
    }
    return string;
}

#pragma mark -- WKUIDelegate --

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.currentUrlString = self.webView.URL.absoluteString;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadFailedView.hidden = YES;
    self.hiddenLoadFaileView = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished)]) {
        [self.delegate loadFinished];
    }
    self.currentTitle = webView.title;
    
    self.loadFailedView.hidden = YES;
    self.hiddenLoadFaileView = YES;
    self.currentUrlString = self.webView.URL.absoluteString;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished)]) {
        [self.delegate loadFinished];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadFinished)]) {
        [self.delegate loadFinished];
    }
    //如果是跳转到appstore，不提示错误
    if (error) {
        NSDictionary * dic = [error userInfo];
        if ([[dic allKeys] containsObject:@"NSErrorFailingURLKey"] ) {
            NSString * stringkey = [NSString stringWithFormat:@"%@",dic[@"NSErrorFailingURLKey"]] ;
            if ([stringkey containsString:@"https://itunes.apple.com/"]) {
                self.webViewStop = NO;
                return ;
            }
        }
    }
    //如果是主动停掉webview加载, 就不在显示error界面
    if (self.webViewStop) {
        self.webViewStop = NO;
    } else {
        //self.loadFailedView.hidden = NO;
        self.hiddenLoadFaileView = NO;
        [self hiddenLoadView];
    }
}
//测试需求 希望加载失败 不要立刻提示失败 给一个缓冲时间
-(void)hiddenLoadView{
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!weakself.hiddenLoadFaileView) {
            self.loadFailedView.hidden = NO;
        }
    });
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSDictionary *allHeaderFields = response.allHeaderFields;
    BOOL ret = [self isDownloadUrlWithHeaderInfo:allHeaderFields urlString:webView.URL.absoluteString];
    if (ret) {
        actionPolicy = WKNavigationResponsePolicyCancel;
        self.webViewStop = YES;
    }
    decisionHandler(actionPolicy);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSURL *requestUrl = navigationAction.request.URL;
    /* 判断打开的链接是否是跳转到AppStore的和跳转到app的 */
    if ([requestUrl.scheme isEqualToString:@"itms-apps"] ||
        [requestUrl.absoluteString containsString:@"//itunes.apple.com"] ||
        [requestUrl.scheme isEqualToString:@"tel"] ||
        [requestUrl.scheme isEqualToString:@"itms-services"]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:requestUrl options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:requestUrl];
        }
        actionPolicy = WKNavigationActionPolicyCancel;
    }
    decisionHandler(actionPolicy);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    // 解决网页加载完成之后, 界面依然空白
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
    return;
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(disposition, credential);
        }
        /* NTLM认证方式 */
    } else if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM]) {
        if ([challenge previousFailureCount] == 0) {
            self.loadingView.hidden = YES;
            [self showNTLMAuthAlertView:^(BOOL confirm, NSString *userName, NSString *password) {
                if (confirm) {
                    NSURLCredential *credential = [NSURLCredential credentialWithUser:userName password:password persistence:NSURLCredentialPersistenceForSession];
                    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
                } else {
                    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
                }
            }];
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        completionHandler(disposition, nil);
    }
}


/// 是否是无效的证书凭据
/// @param credential YES:无效
- (BOOL)credentialIsInValiad:(NSURLCredential *)credential {
    if (credential.identity == nil && credential.certificates == nil) {
        return YES;
    }
    return NO;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    NSLog(@"%@",completionHandler);
}

#pragma mark -- WKNavigationDelegate --

#pragma mark -- NTLM --

- (void)showNTLMAuthAlertView:(void(^)(BOOL confirm, NSString *userName, NSString *password))completioner {
    
}

#pragma mark -- 证书验证 --

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    // 无论神马情况神马配置，CA证书能校验成功，都ok!
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    if(ServerTrustIsValid(serverTrust)) {
        return YES;
    }
    
    return NO;
}

static BOOL ServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    __Require_noErr_Quiet(SecTrustEvaluate(serverTrust, &result), _out);
    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
_out:
    return isValid;
}

- (void)releaseObjc {
    self.delegate = nil;
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:@"BrowserWebView_self"];
    [self.webView removeFromSuperview];
}

#pragma mark 键盘弹出动画
// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    if (!_homePage) {
        return;
    }
    
    CGFloat bgHeight = kScreenWidth*145/375;
    CGFloat bgWidth = bgHeight*1.16;

    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){

        [self.topBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            //make.top.equalTo(@(30));
            make.centerX.equalTo(self);
            make.height.equalTo(@(bgHeight*0.8));
            make.width.equalTo(@(bgWidth*0.8));
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(30+26+bgHeight*0.8);
        }];
        [UIView animateWithDuration:3 animations:^{
            [self layoutIfNeeded];
        }];
    }else{
        [self.topBgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(bgWidth));
            make.height.equalTo(@(bgHeight));
            make.centerX.equalTo(self);
        }];
        [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(bgHeight+26+30);
        }];
        [UIView animateWithDuration:3 animations:^{
            [self layoutIfNeeded];
        }];
    }
   
}

#pragma mark -- 下载管理 --

- (BOOL)isDownloadUrlWithHeaderInfo:(NSDictionary *)headerInfo urlString:(NSString *)urlString {
    NSString *contentType = headerInfo[@"Content-Type"];
    NSString *disposition = headerInfo[@"Content-Disposition"];
    NSString *sufString = [disposition  componentsSeparatedByString:@"."].lastObject.lowercaseString;
    NSString *extensionName = urlString.lastPathComponent.pathExtension.lowercaseString;
    if ([Support_Download_ContentType objectForKey:contentType] ||
        [Support_Download_File_Type containsObject:extensionName] ||
        [Support_Download_File_Type containsObject:sufString]) {
        NSLog(@"下载地址:%@", urlString);
        NSString *createTimeStamp = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]*1000];
        NSString *fileName = [self getDownloadFileName:headerInfo];
        if (fileName.length == 0) {
            fileName = createTimeStamp;
            if (![Support_Download_ContentType objectForKey:contentType]) {
                fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@", extensionName]];
            } else {
                fileName = [fileName stringByAppendingString:[Support_Download_ContentType objectForKey:contentType]];
            }
        }
        if(!extensionName || extensionName.length>6){
             fileName = [fileName stringByAppendingString:[Support_Download_ContentType objectForKey:contentType]];
        }
        DownloadModel *model = [[DownloadModel alloc] init];
        model.downloadUrlString = urlString;
        model.fileName = fileName;
        model.status = Downloading;
        model.createTimeStamp = createTimeStamp;
        NSString *message = [NSString stringWithFormat:@"确定下载文件'%@'", fileName];
        
        UIAlertController *alertController = [CustomAlertVC alertWithTitle:@"提示" message:message letfTitle:@"取消" rightTitle:@"确定" clickCallBack:^(NSInteger index) {
            if (index == 1) {
                if ([WebBroswerManager shareInstance].downloadTasks.count >= 4) {
                    [MBProgressHUD showError:@"已达到最大下载数量,请稍后添加"];
                } else {
                    [[WebBroswerManager shareInstance] addDownloadTask:model];
                    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"文件:%@已加入下载队列", model.fileName]];
                }
            }
        }];
        UIViewController *vc = (UIViewController *)self.superview.nextResponder;
        [vc presentViewController:alertController animated:YES completion:^{}];
        return YES;
    }
    /* 该类型为二进制流类型, 即使不支持下载, 也不允许跳转 */
    if ([contentType isEqualToString:@"application/octet-stream"]) {
        return YES;
    }
    return NO;
}

/**
 获取下载文件的文件名

 @param headerInfo 下载文件头信息
 @return 文件真实名字
 */
- (NSString *)getDownloadFileName:(NSDictionary *)headerInfo {
    NSString *contentDisposition = headerInfo[@"Content-Disposition"];
    contentDisposition = [contentDisposition stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *keysArray = [contentDisposition componentsSeparatedByString:@";"];
    NSString *fileName = @"";
    for (NSString *key in keysArray) {
        if ([key hasPrefix:@"filename"]) {
            fileName = key;
            break;
        }
    }
    NSArray *fileNameArray = [fileName componentsSeparatedByString:@"="];
    if (fileNameArray.count > 1) {
        fileName = fileNameArray[1];
    }
    fileName = [fileName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return fileName;
}

- (void)dealloc {
    NSLog(@"--dealloc---");
    self.delegate = nil;
    @try {
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:@"BrowserWebView_self"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
    }
}



@end
