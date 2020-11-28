//
//  StoreUserDefaultManager.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation

// key
let PrivateWorkspacePasswordKey = "__PrivateWorkspacePasswordKey__"


class StoreUserDefaultManager: NSObject {
    let defaults = UserDefaults.standard
    
    func setValueForKey(key:String, value:String) {
        defaults.setValue(value, forKey: key)
    }
    
    func getValueWithKey(key:String) -> String {
        var value:String??
        value = defaults.value(forKey: key) as? String
        return value! ?? ""
    }
    
    func removeValue(key:String) {
        defaults.removeObject(forKey: key)
    }
}
