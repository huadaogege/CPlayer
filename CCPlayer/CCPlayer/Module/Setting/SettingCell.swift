//
//  SettingCell.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/19.
//

import Foundation
import UIKit

class SettingCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        self.addSubview(self.titleLabel)
    }
    
    lazy var titleLabel = {() -> UILabel in
        let label = UILabel.init()
        label.backgroundColor = UIColor.green
        label.text = "占位字符"
        label.frame = CGRect(x: 10, y: 10, width: 200, height: 40)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    func setTitle(title:String) {
        self.titleLabel.text = title
    }
}
