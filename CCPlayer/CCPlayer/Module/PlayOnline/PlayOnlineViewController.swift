//
//  PlayOnlineViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit

class PlayOnlineViewController: UIViewController {
    
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
    }
    
    lazy var searchTextField = {() -> UITextField in
        var searchTextField = UITextField.init(frame: CGRect(x: 20, y: 150, width: screenObject.width - 40 - 85, height: 45))
        searchTextField.backgroundColor = UIColor.green
        searchTextField.layer.cornerRadius = 4
        searchTextField.layer.masksToBounds = true
        searchTextField.placeholder = "请输入视频链接"
        return searchTextField
    }()
    
    lazy var searchButton = {() -> UIButton in
        var searchButton = UIButton.init(frame: CGRect(x: self.searchTextField.frame.origin.x + self.searchTextField.frame.size.width + 5, y: 150, width: 80, height: 45))
        searchButton.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        searchButton.backgroundColor = UIColor.blue
        searchButton.layer.cornerRadius = 4
        searchButton.layer.masksToBounds = true
        searchButton.titleLabel?.text = "搜索"
        searchButton.titleLabel?.textColor = UIColor.white
        
        return searchButton
    }()
    
    @objc func searchButtonClick() {
        self.searchTextField.resignFirstResponder()
        let model = PlayModel.init(name: "", size: "", time: "在线播放", path: "", icon: UIImage.init())
        let playVC = PlayerViewController()
        playVC.initModel(model)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(playVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
