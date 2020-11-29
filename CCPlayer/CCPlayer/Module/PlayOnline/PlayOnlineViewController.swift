//
//  PlayOnlineViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit
import WebKit

class PlayOnlineViewController: UIViewController, WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
    
    let screenObject = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.white
        self.title = "在线播放"
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.searchButton)
        self.view.addSubview(self.webView)
    }
    
    lazy var searchTextField = {() -> UITextField in
        var searchTextField = UITextField.init(frame: CGRect(x: 20,
                                                             y: 150,
                                                             width: screenObject.width - 40 - 85,
                                                             height: 45))
        searchTextField.layer.cornerRadius = 4
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.borderWidth = 1
        searchTextField.leftView = UIView.init(frame: CGRect(x: 0,
                                                             y: 0,
                                                             width: 20,
                                                             height: 20))
        searchTextField.placeholder = "请输入搜索内容或视频链接"
        return searchTextField
    }()
    
    lazy var searchButton = {() -> UIButton in
        var searchButton = UIButton.init(frame: CGRect(x: self.searchTextField.frame.origin.x + self.searchTextField.frame.size.width + 5,
                                                       y: 150,
                                                       width: 80,
                                                       height: 45))
        searchButton.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        searchButton.layer.cornerRadius = 4
        searchButton.layer.masksToBounds = true
        searchButton.backgroundColor = UIColor.gray
        searchButton.setTitle("搜索", for: .normal)
        searchButton.titleLabel?.textColor = UIColor.white
        
        return searchButton
    }()
    
    lazy var webView: WKWebView = {
        let myWebView = WKWebView.init(frame: self.view.frame)
        let web_url = URL.init(string: "https://www.baidu.com")
        myWebView.load(URLRequest.init(url: web_url!))
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        return myWebView
    }()

    lazy var webConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration.init()
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        configuration.userContentController = self.webUserContentController
        return configuration
    }()
    
    lazy var webUserContentController: WKUserContentController = {
        let userConetentController = WKUserContentController.init()
        userConetentController.add(self, name: "webViewApp")
        return userConetentController
    }()
    
    @objc func searchButtonClick() {
        self.searchTextField.resignFirstResponder()
        if self.searchTextField.text?.count == 0 {
            return
        }
        self.view.addSubview(self.webView)
    }
    
    // wkwebviewDelegate
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    //MARK:-WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }

    //MARK:-WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //页面开始加载，可在这里给用户loading提示
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //内容开始到达时
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //页面加载完成时
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //页面加载出错，可在这里给用户错误提示
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        //收到服务器重定向请求
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 在请求开始加载之前调用，决定是否跳转
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //在收到响应开始加载后，决定是否跳转
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
}
