//
//  PasswordView.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit

enum PwdType:Int {
    case PwdNeedUnlock, PwdNeedSet
}

class PasswordView: UIView, UITextFieldDelegate {
    
    let screenObject = UIScreen.main.bounds
    var dotImages = Array<UIImageView>()
    var password:String = ""
    var pwdType:PwdType!
    
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
        
    }
    
    lazy var pwdView = {() -> UIView in
        
        var pwdView = UIView.init(frame: CGRect(x: (screenObject.width - 200)/2.0,
                                                y: 200,
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
            dotImage.backgroundColor = UIColor.red
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
        NSLog("password:  %@", password)
        let pwdCount = password.count - 1
        for index in 0 ... 5 {
            let image = dotImages[index]
            if index <= pwdCount {
                image.backgroundColor = UIColor.green
            } else {
                image.backgroundColor = UIColor.red
            }
        }
    }
    
    // delegate
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
