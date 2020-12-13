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
        self.tabBar.tintColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
        
        let fileListVC = FileListViewController()
        let fileListNav = UINavigationController(rootViewController: fileListVC)
        fileListNav.navigationBar.barTintColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
        fileListNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial",size: 18)!,NSAttributedString.Key.foregroundColor:UIColor.white]

        fileListNav.tabBarItem = UITabBarItem(title: "列表", image: UIImage(named: "filelist"), selectedImage: UIImage(named: ""))
        
        let photoAlbumVC = PhotoAlbumViewController()
        let photoAlbumNav = UINavigationController.init(rootViewController: photoAlbumVC)
        photoAlbumNav.navigationBar.barTintColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
        photoAlbumNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial",size: 18)!,NSAttributedString.Key.foregroundColor:UIColor.white]
        photoAlbumNav.tabBarItem = UITabBarItem(title: "相册", image: UIImage(named: "album"), selectedImage: UIImage(named: ""))
        
        let playOnlineVC = PlayOnlineViewController()
        let playOnlineNav = UINavigationController(rootViewController: playOnlineVC)
        playOnlineNav.navigationBar.barTintColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
        playOnlineNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial",size: 18)!,NSAttributedString.Key.foregroundColor:UIColor.white]
        playOnlineNav.tabBarItem = UITabBarItem(title: "在线", image: UIImage(named: "online"), selectedImage: UIImage(named: ""))
        
        
        let setVC = SettingViewController()
        let setNav = UINavigationController(rootViewController: setVC)
        setNav.navigationBar.barTintColor = UIColor(red: 30/255, green:0/255, blue:202/255, alpha:1)
        setNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Arial",size: 18)!,NSAttributedString.Key.foregroundColor:UIColor.white]
        setNav.tabBarItem = UITabBarItem(title: "设置", image: UIImage(named: "setting"), selectedImage: UIImage(named: ""))
        
        self.viewControllers = [fileListNav, photoAlbumNav, playOnlineNav, setNav]
        self.selectedIndex = 0
    }
    
    
}
