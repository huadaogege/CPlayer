//
//  PrivateSettingViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit

class PrivateSettingViewController: UIViewController, PasswordViewDelegate {
    
    var screenObject = UIScreen.main.bounds
    var pwdType:PwdType = PwdType.PwdUnknown
    let storeManager = StoreUserDefaultManager.init()
    var pwdView = PasswordView.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let ConfigCenterInstance = ConfigCenter()
        
        let privatePwdIsSet:Bool = ConfigCenterInstance.privateWorkspacePwdIsSet()
        pwdType = privatePwdIsSet ? PwdType.PwdNeedUnlock:PwdType.PwdNeedSet
        self.pwdView = passwordView()
        self.pwdView.setPwdType(pwdType: pwdType)
        self.view.addSubview(self.pwdView)
    }
    
    func passwordView() -> PasswordView {
        let pwdView = PasswordView.init(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: screenObject.width,
                                                      height: screenObject.height))
        pwdView.delegate = self
        return pwdView
    }
    
    func passwordInputFinish(password: String) {
        if self.pwdType == PwdType.PwdNeedUnlock {
            let savedPwd = storeManager.getValueWithKey(key: PrivateWorkspacePasswordKey)
            if savedPwd == password {
                self.pwdView.removeFromSuperview()
                let playListVC = PlayListViewController.init()
                playListVC.setIsPrivate(isPrivate: true)
                self.addChild(playListVC)
                self.view.addSubview(playListVC.view)
            } else {
                self.pwdView.removeFromSuperview()
                self.pwdView = passwordView()
                self.pwdView.setPwdType(pwdType: PwdType.PwdError)
                self.view.addSubview(self.pwdView)
            }
        } else if self.pwdType == PwdType.PwdNeedSet {
            storeManager.setValueForKey(key: PrivateWorkspacePasswordKey, value: password)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
