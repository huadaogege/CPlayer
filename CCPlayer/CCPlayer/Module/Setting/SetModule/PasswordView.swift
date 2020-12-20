//
//  PasswordView.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit

enum PwdType:Int {
    case PwdUnknown = 0,
         PwdNeedUnlock = 1,
         PwdNeedSet = 2,
         PwdError = 3
}

protocol PasswordViewDelegate:NSObjectProtocol {
    func passwordInputFinish(password:String)
}

class PasswordView: UIView, UITextFieldDelegate {
    
    weak var delegate:PasswordViewDelegate?
    let screenObject = UIScreen.main.bounds
    var dotImages = Array<UIImageView>()
    var password:String = ""
    var pwdType:PwdType = PwdType.PwdUnknown
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.addSubview(pwdView)
        self.addSubview(self.textField)
        self.textField.becomeFirstResponder()
        self.addSubview(self.tipLabel)
    }
    
    func setPwdType(pwdType:PwdType) {
        self.pwdType = pwdType
        if self.pwdType == PwdType.PwdNeedUnlock {
            self.tipLabel.text = "请输入密码"
        } else if self.pwdType == PwdType.PwdNeedSet {
            self.tipLabel.text = "请设置密码"
        } else if self.pwdType == PwdType.PwdError {
            self.tipLabel.text = "密码错误,请重新输入"
            self.tipLabel.textColor = UIColor.red
        }
    }
    
    lazy var tipLabel = {() -> UILabel in
        var tipLabel = UILabel.init(frame: CGRect(x: 0,
                                                  y: 170,
                                                  width: screenObject.width,
                                                  height: 30))
        tipLabel.font = UIFont.systemFont(ofSize: 20)
        tipLabel.textColor = UIColor.gray
        tipLabel.textAlignment = .center
        return tipLabel
    }()
    
    lazy var pwdView = {() -> UIView in
        
        var pwdView = UIView.init(frame: CGRect(x: (screenObject.width - 200)/2.0,
                                                y: 250,
                                                width: 200,
                                                height: 30))
        let space:Int = 15
        let dotWidth:Int = Int((200 - 15*5)/6.0)
        for index in 0...5 {
            var dotImage:UIImageView = UIImageView.init()
            dotImage.frame = CGRect(x: (space + dotWidth)*index,
                                    y: 0,
                                width: dotWidth,
                               height: dotWidth)
            dotImage.layer.cornerRadius = CGFloat(dotWidth)/2.0
            dotImage.layer.masksToBounds = true
            dotImage.backgroundColor = UIColor.lightGray
            pwdView.addSubview(dotImage)
            dotImages.append(dotImage)
        }
        return pwdView
    }()
    
    lazy var textField = {() -> UITextField in
        var textField = UITextField.init()
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        return textField
    }()
    
    func updateDots() {
        // 更新UI
        print("password:", password)
        let pwdCount = password.count - 1
        for index in 0 ... 5 {
            let image = dotImages[index]
            if index <= pwdCount {
                image.backgroundColor = UIColor(red: 13/255, green:107/255, blue:13/255, alpha:1)
            } else {
                image.backgroundColor = UIColor.lightGray
            }
        }
        // 验证设置密码
        if password.count == 6 {
            if (self.delegate != nil) {
                self.delegate?.passwordInputFinish(password: password)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NSLog("%@", self.textField.text ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NSLog("%@", self.textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text:String = self.textField.text ?? ""
        let tmp = text + string
        if tmp.count <= 6 {
            if string.count == 0 {
                password = String(tmp.prefix(tmp.count - 1))
            } else {
                password = tmp
            }
        } else {
            self.textField.text = password
        }
        updateDots()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        NSLog("%@", self.textField.text ?? "")
        return true
    }
    
}
