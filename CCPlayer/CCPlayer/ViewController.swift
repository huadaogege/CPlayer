//
//  ViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 初始化导航条
        initNavPerf()
        
        let mainVC = MainViewController()
        
        self.addChild(mainVC)
        self.view.addSubview(mainVC.view)
        
    }
    
    func initNavPerf() -> Void {
        let leftItem = UIBarButtonItem(title: "CC Player", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        let img = UIImage(named: "nav_CloseBtn")        
        let rightItem1 = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightItem1Selector))
        
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = rightItem1
    }
    
    @objc func rightItem1Selector() -> Void {
        NSLog("rightItem1Selector click")
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }


}

