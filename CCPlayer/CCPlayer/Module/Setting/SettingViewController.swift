//
//  SettingViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/18.
//

import Foundation
import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var screenObject = UIScreen.main.bounds
    
    var tableView : UITableView!
    var dataItems = ["隐私空间", "开启扫描相册数据", "关于CCPlayer"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() -> Void {
        self.title = "设置"
        self.view.backgroundColor = UIColor.lightGray
        createTable()
    }
    
    func createTable() -> Void {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenObject.width, height: screenObject.height), style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "setting_cell_identifier"
        var cell:SettingCell!
        cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SettingCell
        if (cell == nil) {
            cell = SettingCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        cell?.backgroundColor = UIColor.yellow
        cell.setTitle(title: self.dataItems[indexPath.row])
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let privateWorkspaceVC = PrivateSettingViewController()
            self.navigationController?.pushViewController(privateWorkspaceVC, animated: true)
        }
    }
}
