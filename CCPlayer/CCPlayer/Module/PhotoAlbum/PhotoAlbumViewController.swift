//
//  PhotoAlbum.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/29.
//

import Foundation
import UIKit
import Photos

class PhotoAlbumViewController: UIViewController {
    
    let commonUtil = CommonUtil.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if commonUtil.needGotoSettingToOpenAccessAlbum() {
            return;
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async {
                        let playVC = PlayListViewController()
                        playVC.setType(type: Type.PhotoAlbumList)
                        self.view.addSubview(playVC.view)
                        self.addChild(playVC)
                    }
                } else if status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.restricted {
                    
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func initView() {
        self.title = "系统相册"
        if commonUtil.photoAlbumIsAuthorized() {
            let playVC = PlayListViewController()
            playVC.setType(type: Type.PhotoAlbumList)
            self.view.addSubview(playVC.view)
            self.addChild(playVC)
        }
    }

}
