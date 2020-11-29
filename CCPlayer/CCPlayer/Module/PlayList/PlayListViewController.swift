//
//  PlayListViewController.swift
//  CCPlayer
//
//  Created by cuiyuguan on 2020/11/21.
//

import Foundation
import UIKit
import AVFoundation

class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlayListCellDelegate {
    var screenObject = UIScreen.main.bounds
    var dataItems : Array<Any>! = Array.init()
    var edit:Bool = false
    var isPrivate:Bool = false
    var selectDataItems : Array<Any> = Array.init()
    let cfManager = CFileManager.init()
    
    // override 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        updateData()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        self.hidesBottomBarWhenPushed = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        let rightButtonName = self.edit ? "完成":"编辑"
        
        let rightButton = UIBarButtonItem(title: rightButtonName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButtonClick))
            self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    override var shouldAutorotate:Bool {
        return true
    }
    
    // UI界面创建
    func initView() {
        let title = self.isPrivate ? "加密列表":"播放列表"
        self.navigationController?.title = title
        self.view.backgroundColor = UIColor.cyan
        self.view.addSubview(tableView)
        if self.edit {
            self.view.addSubview(editBottomView)
        }
    }
    
    lazy var tableView = {() -> UITableView in
        var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height), style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var editBottomView = {() -> UIView in
        var editBottomView = UIView.init(frame: CGRect(x: 0,
                                                       y: screenObject.height - 80,
                                                       width: screenObject.width,
                                                       height: 80))
        editBottomView.backgroundColor = UIColor.white
        let editTitles = ["全选", "删除", "加密"]
        let space = 30
        let buttonWidth = (screenObject.width - CGFloat(space*4))/3.0
        for index in 0 ... 2 {
            let button = UIButton.init(frame: CGRect(x: CGFloat(space) + (CGFloat(space) + buttonWidth)*CGFloat(index),
                                                     y: 5,
                                                     width: buttonWidth,
                                                     height: 40))
            button.setTitle(editTitles[index], for: .normal)
            if index == 0 {
                button.setTitle("反选", for: .selected)
            }
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.gray
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            button.tag = index
            button.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
            editBottomView.addSubview(button)
        }
        return editBottomView
    }()
    
    @objc func editButtonClick(sender:UIButton) {
        let tag = sender.tag
        if tag == 0 {
            sender.isSelected = !sender.isSelected
            self.selectDataItems.removeAll()
            if sender.isSelected {
                self.selectDataItems.append(contentsOf: self.dataItems)
            }
            self.tableView.reloadData()
        } else if tag == 1 {
            if self.selectDataItems.count == 0 {
                return
            }
            for model in self.selectDataItems {
                let fileManager = FileManager.default
                try!fileManager.removeItem(atPath: (model as! PlayModel).path)
            }
            updateData()
        } else if tag == 2 {
            if self.selectDataItems.count == 0 {
                return
            }
            for model in self.selectDataItems {
                cfManager.moveToPrivatePath(path: (model as! PlayModel).path)
            }
            updateData()
        }
    }
    
    // 调用方法
    func setVCType(edit:Bool) {
        self.edit = edit
    }
    
    func setIsPrivate(isPrivate:Bool) {
        self.isPrivate = isPrivate
    }
    
    @objc func rightButtonClick() {
        if self.edit {
            self.navigationController?.dismiss(animated: true, completion: {})
        } else {
            let playListVC = PlayListViewController()
            playListVC.setVCType(edit: true)
            let playListNav = UINavigationController.init(rootViewController: playListVC)
            
            playListNav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.present(playListNav, animated: true, completion: {})
        }
    }
    
    func updateData() {
//        SwiftProgressHUD.showWait()
        DispatchQueue.global().async { [self] in
            dataItems = cfManager.preparePlayModels(isPrivate: self.isPrivate)
            DispatchQueue.main.async {
//                SwiftProgressHUD.hideAllHUD()
                self.tableView.reloadData()
            }
        }
    }
    
    // tableViewDelegate 方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "playList_cell_identifier"
        var cell:PlayListCell!
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PlayListCell
        if (cell == nil) {
            cell = PlayListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        cell.delegate = self
        let model = self.dataItems[indexPath.row]
        cell.setModel(model: model as! PlayModel)
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.setEditing(isEdit: self.edit)
        if self.selectDataItems.count == self.dataItems.count {
            cell.selectButton.isSelected = true
        } else if self.selectDataItems.count == 0 {
            cell.selectButton.isSelected = false
        }
        return cell!
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.edit {
            return
        }
        let model = self.dataItems[indexPath.row]
        let playVC = PlayerViewController()
        playVC.initModel(model as! PlayModel)
        self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(playVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func selectCell(model:PlayModel, selected:Bool) {
        if selected {
            self.selectDataItems.append(model)
        } else {
            let index = self.selectDataItems.firstIndex { (e) -> Bool in
                return model.path == (e as! PlayModel).path
            }
            self.selectDataItems.remove(at: index!)
        }
    }
    
    
}
