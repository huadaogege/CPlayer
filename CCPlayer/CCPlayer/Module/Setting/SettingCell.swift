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
    
    func setTitle(title:String) {
        self.titleLabel.text = title
        if title == "存储空间" {
            self.rightLabel.isHidden = false
            self.rightLabel.text = "剩余:" + OCClass.memoryFree()
        } else {
            self.rightLabel.isHidden = true
            self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
    }
}
