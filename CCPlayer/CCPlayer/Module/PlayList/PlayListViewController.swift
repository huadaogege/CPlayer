//
//  PlayListViewController.swift
//  CCPlayer
//
//  Created by cuiyuguan on 2020/11/21.
//

import Foundation
import UIKit
import AVFoundation

enum Type:Int {
    case Unknown = 0,
         FileList = 1,
         FileEditList = 2,
         PrivateList = 3,
         PhotoAlbumList = 4
}

class PlayListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PlayListCellDelegate {
    var screenObject = UIScreen.main.bounds
    var dataItems : Array<Any>! = Array.init()
    
    var vcType = Type.Unknown
    
    var searchPathIsPrivate = false
    
    var selectDataItems : Array<Any> = Array.init()
    let cfManager = CFileManager.init()
    let playFileParser = PlayFileParser.init()
    
    // override 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        self.hidesBottomBarWhenPushed = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        if self.vcType == Type.FileList {
            let superVC:UIViewController = self.view.superview?.next as! UIViewController
            
            let rightButton1 = UIBarButtonItem(title: "录制", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButton1Click))
            rightButton1.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial",size: 16)!,
                                                 NSAttributedString.Key.foregroundColor:UIColor.white], for: UIControl.State.normal)
            
            let rightButtonName2 = (self.vcType == Type.FileEditList) ? "完成":"编辑"
            let color = (self.vcType == Type.FileEditList) ? UIColor.black : UIColor.white
            let rightButton2 = UIBarButtonItem(title: rightButtonName2, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButtonClick))
            rightButton2.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial",size: 16)!,
                                                NSAttributedString.Key.foregroundColor:color], for: UIControl.State.normal)
            
            if self.vcType == Type.FileEditList {
                superVC.navigationItem.rightBarButtonItem = rightButton2
            } else {
                superVC.navigationItem.rightBarButtonItems = [rightButton2, rightButton1]
            }
        }
        if self.vcType == Type.FileEditList {
            let rightButtonName = (self.vcType == Type.FileEditList) ? "完成":"编辑"
            let color = (self.vcType == Type.FileEditList) ? UIColor.black : UIColor.white
            let rightButton = UIBarButtonItem(title: rightButtonName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButtonClick))
            rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial",size: 16)!,
                                                NSAttributedString.Key.foregroundColor:color], for: UIControl.State.normal)
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.vcType == Type.PrivateList {
            let superVC:UIViewController = self.view.superview?.next as! UIViewController
            let rightButtonName = (self.vcType == Type.FileEditList) ? "完成":"编辑"
            let color = (self.vcType == Type.FileEditList) ? UIColor.black : UIColor.white
            let rightButton = UIBarButtonItem(title: rightButtonName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightButtonClick))
            rightButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial",size: 16)!,
                                                NSAttributedString.Key.foregroundColor:color], for: UIControl.State.normal)
            superVC.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    override var shouldAutorotate:Bool {
        return true
    }
    
    // UI界面创建
    func initView() {
        let title = (self.vcType == Type.PrivateList) ? "加密列表":"播放列表"
        self.navigationController?.title = title
        self.view.backgroundColor = UIColor.cyan
        self.view.addSubview(tableView)
        if (self.vcType == Type.FileEditList) {
            self.view.addSubview(editBottomView)
        }
    }
    
    lazy var fileListTipsView = {() -> UIView in
        var tipsView = UIView.init(frame: CGRect(x: (screenObject.width - 250)/2.0,
                                                 y: (screenObject.height - 300)/4.0,
                                                 width: 250,
                                                 height: 300))
        
        let tipsImage = UIImageView.init(frame: CGRect(x: (250 - 80)/2.0,
                                                       y: 0,
                                                       width: 80,
                                                       height: 80))
        tipsImage.backgroundColor = UIColor.green
        tipsView.addSubview(tipsImage)
        
        let tipsLabel = UILabel.init(frame: CGRect(x: 0,
                                                   y: 100,
                                                   width: 250,
                                                   height: 150))
        tipsLabel.font = UIFont.systemFont(ofSize: 15)
        tipsLabel.textAlignment = NSTextAlignment.left
        tipsLabel.numberOfLines = 0
        tipsLabel.textColor = UIColor.gray
        tipsLabel.text = "当前播放列表为空\n\n可以尝试：\n1.手机连接电脑，通过电脑同步\n2.通过该应用录制视频，视频只会保存到该应用中"
        
        tipsView.addSubview(tipsLabel)
        return tipsView
    }()
    
    lazy var tableView = {() -> UITableView in
        var tableView = UITableView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: screenObject.width,
                                                  height: screenObject.height),
                                    style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        
        return tableView
    }()
    
    lazy var editBottomView = {() -> UIView in
        var editBottomView = UIView.init(frame: CGRect(x: 0,
                                                       y: screenObject.height - 100,
                                                       width: screenObject.width,
                                                       height: 100))
        editBottomView.backgroundColor = UIColor.white
        var editTitles = ["全选", "删除", "加密"]
        if self.searchPathIsPrivate {
            editTitles = ["全选", "删除", "解密"]
        }
        let space = 35
        let buttonWidth = (screenObject.width - CGFloat(space*4))/3.0
        for index in 0 ... 2 {
            let button = UIButton.init(frame: CGRect(x: CGFloat(space) + (CGFloat(space) + buttonWidth)*CGFloat(index),
                                                     y: 5,
                                                     width: buttonWidth,
                                                     height: 40))
            button.setTitle(editTitles[index], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            if index == 0 {
                button.setTitle("反选", for: .selected)
            }
            if index == 0 {
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = UIColor.white
            } else if index == 1 {
                button.setTitleColor(UIColor.black, for: .normal)
                button.backgroundColor = UIColor.init(red: 233/255.0, green: 234/255.0, blue: 235/255.0, alpha: 1.0)
            } else if index == 2 {
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
            }
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
                MBProgressHUD.showError("请至少选择一项数据")
                return
            }
            for model in self.selectDataItems {
                let fileManager = FileManager.default
                try!fileManager.removeItem(atPath: (model as! PlayModel).path)
            }
            updateData()
        } else if tag == 2 {
            if self.selectDataItems.count == 0 {
                MBProgressHUD.showError("请至少选择一项数据")
                return
            }
            if !self.searchPathIsPrivate {
                let config = ConfigCenter()
                if !config.privateWorkspacePwdIsSet() {
                    MBProgressHUD.showError("请先到设置中设置隐私空间密码")
                    return
                }
            }
            for model in self.selectDataItems {
                if self.searchPathIsPrivate {
                    cfManager.moveToPublicPath(path: (model as! PlayModel).path)
                } else {
                    cfManager.moveToPrivatePath(path: (model as! PlayModel).path)
                }
                self.selectDataItems.removeAll()
            }
            updateData()
        }
    }
    
    func setType(type:Type) {
        self.vcType = type
    }
    
    func setSearchIsPrivate(isPrivate:Bool) {
        self.searchPathIsPrivate = isPrivate
    }
    
    @objc func rightButton1Click() {
        let shootVC = ShootViewController.init()
        shootVC.setParams()
        shootVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(shootVC, animated: true) {}
    }
    
    @objc func rightButtonClick() {
        if (self.vcType == Type.FileEditList) {
            self.navigationController?.dismiss(animated: true, completion: {})
        } else if (self.vcType == Type.PrivateList) {
            if self.dataItems.count == 0 {
                MBProgressHUD.showError("播放列表为空")
                return
            }
            let playListVC = PlayListViewController()
            playListVC.setType(type: Type.FileEditList)
            playListVC.setSearchIsPrivate(isPrivate: true)
            let playListNav = UINavigationController.init(rootViewController: playListVC)
            
            playListNav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.present(playListNav, animated: true, completion: {})
        } else {
            if self.dataItems.count == 0 {
                MBProgressHUD.showError("播放列表为空")
                return
            }
            let playListVC = PlayListViewController()
            playListVC.setType(type: Type.FileEditList)
            playListVC.setSearchIsPrivate(isPrivate: false)
            let playListNav = UINavigationController.init(rootViewController: playListVC)
            
            playListNav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.present(playListNav, animated: true, completion: {})
        }
    }
    
    func updateData() {
        MBProgressHUD.showLoadingMessage("正在加载数据")
        if (self.vcType == Type.PhotoAlbumList) {
            DispatchQueue.global().async {
                PhotoManager.videoInfoOfsystem { (playmodels) in
                    DispatchQueue.main.async {
                        MBProgressHUD.hide()
                        self.dataItems = playmodels
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            DispatchQueue.global().async { [self] in
                dataItems = cfManager.preparePlayModels(isPrivate: self.searchPathIsPrivate)
                DispatchQueue.main.async {
                    MBProgressHUD.hide()
                    if dataItems.count == 0 && self.vcType == Type.FileList {
                        self.tableView.addSubview(self.fileListTipsView)
                    } else {
                        self.fileListTipsView.removeFromSuperview()
                    }
                    self.tableView.reloadData()
                }
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
        return 100
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
        cell.setEditing(isEdit: (self.vcType == Type.FileEditList))
        if self.selectDataItems.count == self.dataItems.count {
            cell.selectButton.isSelected = true
        } else if self.selectDataItems.count == 0 {
            cell.selectButton.isSelected = false
        }
        return cell!
    }
    
    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.vcType == Type.FileEditList) {
            return
        }
        let model = self.dataItems[indexPath.row]
        let playVC = OPlayerViewController.init(playModel: model as! PlayModel)
        playVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        playVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(playVC, animated: true)
        playVC.hidesBottomBarWhenPushed = false
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
