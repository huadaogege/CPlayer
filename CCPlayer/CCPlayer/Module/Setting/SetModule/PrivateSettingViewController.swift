//
//  PrivateSettingViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit

class PrivateSettingViewController: UIViewController {
    
    var screenObject = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let ConfigCenterInstance = ConfigCenter()
        
        let privatePwdIsSet:Bool = ConfigCenterInstance.privateWorkspacePwdIsSet()
        
        if privatePwdIsSet {
            let pwdView = PasswordView.init(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: screenObject.width,
                                                          height: screenObject.height))
            self.view.addSubview(pwdView)
        } else {
            let pwdView = PasswordView.init(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: screenObject.width,
                                                          height: screenObject.height))
            self.view.addSubview(pwdView)
        }
    }
    
    
    
}
