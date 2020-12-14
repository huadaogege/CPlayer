//
//  SettingCell.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/19.
//

import Foundation
import UIKit

class SettingCell: UITableViewCell {
    
    let screenObject = UIScreen.main.bounds
    let commonUtil = CommonUtil()
    let store = StoreUserDefaultManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.rightLabel)
        self.rightLabel.isHidden = true
        self.contentView.addSubview(self.switchButton)
        self.switchButton.isHidden = true
    }
    
    lazy var titleLabel = {() -> UILabel in
        let label = UILabel.init()
        label.text = "占位字符"
        label.frame = CGRect(x: 15, y: 10, width: 150, height: 40)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var rightLabel = {() -> UILabel in
        let label = UILabel.init()
        label.text = ""
        label.frame = CGRect(x: screenObject.width - 90, y: 10, width: 80, height: 40)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var switchButton = {() -> UISwitch in
        let switchBth = UISwitch.init()
        switchBth.frame = CGRect(x: screenObject.width - 90, y: 10, width: 80, height: 40)
        let isOn = store.getValueWithKey(key: FaceOrTouchIDIsOpenKey)
        switchBth.isOn = (isOn == "1")
        switchBth.addTarget(self, action: #selector(switchDidChange), for: UIControl.Event.valueChanged)
        return switchBth
    }()
    
    @objc func switchDidChange() {
        if self.switchButton.isOn {
            let ret = commonUtil.deviceSupportBiometrics()
            if ret {
                commonUtil.authTouchBtnClick { [self] (success) in
                    if (success) {
                        self.store.setValueForKey(key: FaceOrTouchIDIsOpenKey, value: "1")
                    } else {
                        DispatchQueue.main.async {
                            self.switchButton.isOn = false
                        }
                    }
                }
            } else {
                self.switchButton.isOn = false
            }
        } else {
            let isOn = store.getValueWithKey(key: FaceOrTouchIDIsOpenKey)
            if isOn == "1" {
                commonUtil.authTouchBtnClick { [self] (success) in
                    if (success) {
                        self.store.setValueForKey(key: FaceOrTouchIDIsOpenKey, value: "")
                    } else {
                        DispatchQueue.main.async {
                            self.switchButton.isOn = true
                        }
                    }
                }
            }
        }
    }
    
    func setTitle(title:String) {
        self.titleLabel.text = title
        if title == "存储空间" {
            self.rightLabel.isHidden = false
            self.rightLabel.text = "剩余:" + OCClass.memoryFree()
        } else {
            self.rightLabel.isHidden = true
            self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        if title == "开启Touch/FaceID" {
            self.switchButton.isHidden = false
            self.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            self.switchButton.isHidden = true
        }
    }
}
