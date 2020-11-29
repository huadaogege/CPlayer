//
//  PhotoAlbum.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/29.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class PhotoAlbumViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.title = "系统相册"
        let allPhotos = getAllPHAssetFromSysytem()
    }
    
    func getAllPHAssetFromSysytem()->([PHAsset]){
        var arr:[PHAsset] = []
        let options = PHFetchOptions.init()
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(with: options)
        // 遍历，得到每一个图片资源asset，然后放到集合中
        assetsFetchResults.enumerateObjects { (asset, index, stop) in
            arr.append(asset)
        }
        print("\(arr.count)")
        return arr
    }

}
