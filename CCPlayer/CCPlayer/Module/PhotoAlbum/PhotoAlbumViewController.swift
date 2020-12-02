//
//  PhotoAlbum.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/29.
//

import Foundation
import UIKit


class PhotoAlbumViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func initView() {
        self.title = "系统相册"
        let playVC = PlayListViewController()
        playVC.setIsPhotoAlbum(isPhotoAlbum: true)
        self.view.addSubview(playVC.view)
        self.addChild(playVC)
    }

}
