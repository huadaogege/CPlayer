//
//  ConfigCenter.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation

class ConfigCenter: NSObject {
    
    func privateWorkspacePwdIsSet() -> Bool {
        let privatePwd:String = StoreUserDefaultManager().getValueWithKey(key: PrivateWorkspacePasswordKey)
        if privatePwd.count > 0 {
            NSLog("隐私空间密码已设置")
        } else {
            NSLog("隐私空间密码未设置")
        }
        let ret:Bool = privatePwd.count > 0
        return ret
    }
}


