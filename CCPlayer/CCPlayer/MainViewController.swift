//
//  MainViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/21.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 0/255, green:169/255, blue:169/255, alpha:1)
        
        let fileListVC = FileListViewController()
        let fileListNav = UINavigationController(rootViewController: fileListVC)
        fileListNav.tabBarItem = UITabBarItem(title: "列表", image: UIImage(named: "wb_private"), selectedImage: UIImage(named: ""))
        
        let photoAlbumVC = PhotoAlbumViewController()
        let photoAlbumNav = UINavigationController.init(rootViewController: photoAlbumVC)
        photoAlbumNav.tabBarItem = UITabBarItem(title: "相册", image: UIImage(named: "safari"), selectedImage: UIImage(named: ""))
        
        let playOnlineVC = PlayOnlineViewController()
        let playOnlineNav = UINavigationController(rootViewController: playOnlineVC)
        playOnlineNav.tabBarItem = UITabBarItem(title: "在线", image: UIImage(named: "wb_download"), selectedImage: UIImage(named: ""))
        
        
        let setVC = SettingViewController()
        let setNav = UINavigationController(rootViewController: setVC)
        setNav.tabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "wb_refresh"), selectedImage: UIImage(named: ""))
        
        self.viewControllers = [fileListNav, photoAlbumNav, playOnlineNav, setNav]
        self.selectedIndex = 0
    }
    
    
}
