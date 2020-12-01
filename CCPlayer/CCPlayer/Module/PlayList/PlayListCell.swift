//
//  PlayListCell.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/21.
//

import Foundation
import UIKit

protocol PlayListCellDelegate:NSObjectProtocol {
    func selectCell(model:PlayModel, selected:Bool)
}

class PlayListCell: UITableViewCell {
    
    weak var delegate:PlayListCellDelegate?
    
    var playModel = PlayModel.init()
    
    var screenObject = UIScreen.main.bounds
    let selectButtonFrame = CGRect(x: -30, y: 45, width: 20, height: 20)
    let snapImageViewFrame = CGRect(x: 10, y: 15, width: 140, height: 90)
    let nameLabelFrame = CGRect(x: 155, y: 20, width: 180, height: 25)
    let sizeLabelFrame = CGRect(x: 155, y: 60, width: 100, height: 15)
    let timeLabelFrame = CGRect(x: 155, y: 85, width: 120, height: 15)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        self.contentView.addSubview(self.selectButton)
        self.contentView.addSubview(self.snapImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.sizeLabel)
        self.contentView.addSubview(self.timeLabel)
    }
    
    lazy var selectButton = {() -> UIButton in
        var selectButton = UIButton.init()
        selectButton.frame = selectButtonFrame
        selectButton.backgroundColor = UIColor.gray
        selectButton.setBackgroundImage(UIImage.init(named: "radiobtn_unchecked"), for: .normal)
        selectButton.setBackgroundImage(UIImage.init(named: "radiobtn_checked"), for: .selected)
        selectButton.layer.cornerRadius = 10
        selectButton.layer.masksToBounds = true
        selectButton.addTarget(self, action: #selector(selectButtonClick), for: .touchUpInside)
        return selectButton
    }()
    
    lazy var snapImageView = {() -> UIImageView in
        var snapImageView = UIImageView.init()
        snapImageView.backgroundColor = UIColor.lightGray
        snapImageView.frame = snapImageViewFrame
        snapImageView.contentMode = .scaleAspectFill
        snapImageView.layer.cornerRadius = 4
        snapImageView.layer.masksToBounds = true
        return snapImageView
    }()
    
    lazy var nameLabel = {() -> UILabel in
        var nameLabel = UILabel.init(frame:nameLabelFrame)
        nameLabel.text = "视频名字"
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        return nameLabel
    }()
    
    lazy var sizeLabel = {() -> UILabel in
        var sizeLabel = UILabel.init(frame:sizeLabelFrame)
        sizeLabel.text = "1.5GB"
        sizeLabel.font = UIFont.systemFont(ofSize: 12)
        return sizeLabel
    }()
    
    lazy var timeLabel = {() -> UILabel in
        var timeLabel = UILabel.init(frame: timeLabelFrame)
        timeLabel.text = "00:00:00 - 01:30:00"
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        return timeLabel
    }()
    
    func setModel(model:PlayModel) {
        self.playModel = model
        self.snapImageView.image = model.icon
        self.nameLabel.text = model.name
        self.sizeLabel.text = model.size
        self.timeLabel.text = model.time
    }
    
    func setEditing(isEdit:Bool) {
        let displace = isEdit ? 50:0
        
        self.selectButton.frame = CGRect(x: selectButtonFrame.origin.x + CGFloat(displace),
                                          y: selectButtonFrame.origin.y,
                                          width: selectButtonFrame.size.width,
                                          height: selectButtonFrame.size.height)
        self.snapImageView.frame = CGRect(x: snapImageViewFrame.origin.x + CGFloat(displace),
                                          y: snapImageViewFrame.origin.y,
                                          width: snapImageViewFrame.size.width,
                                          height: snapImageViewFrame.size.height)
        self.nameLabel.frame = CGRect(x: nameLabelFrame.origin.x + CGFloat(displace),
                                      y: nameLabelFrame.origin.y,
                                      width: nameLabelFrame.size.width,
                                      height: nameLabelFrame.size.height)
        self.sizeLabel.frame = CGRect(x: sizeLabelFrame.origin.x + CGFloat(displace),
                                      y: sizeLabelFrame.origin.y,
                                      width: sizeLabelFrame.size.width,
                                      height: sizeLabelFrame.size.height)
        self.timeLabel.frame = CGRect(x: timeLabelFrame.origin.x + CGFloat(displace),
                                      y: timeLabelFrame.origin.y,
                                      width: timeLabelFrame.size.width,
                                      height: timeLabelFrame.size.height)
    }
    
    @objc func selectButtonClick() {
        self.selectButton.isSelected = !self.selectButton.isSelected
        if (self.delegate != nil) {
            self.delegate?.selectCell(model: self.playModel, selected: self.selectButton.isSelected)
        }
    }
}
