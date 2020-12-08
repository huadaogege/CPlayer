//
//  FileListViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/12/4.
//

import Foundation
import UIKit

class FileListViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.title = "文件列表"
        let playVC = PlayListViewController()
        playVC.setType(type: Type.FileList)
        self.addChild(playVC)
        self.view.addSubview(playVC.view)
    }
    
}
