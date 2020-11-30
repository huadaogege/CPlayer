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
    
    let playFileParser = PlayFileParser.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.title = "系统相册"
        
    }
    
    func getAllPHAssetFromSysytem(completion: @escaping (Array<PlayModel>)->())  {
        var arr = Array<PlayModel>()
        var assets = Array<PHAsset>()
        
        let options = PHFetchOptions.init()
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(with: options)
        // 遍历，得到每一个图片资源asset，然后放到集合中
        assetsFetchResults.enumerateObjects { (asset, index, stop) in
            if asset.mediaType == .video {
                let options = PHVideoRequestOptions()
                options.version = PHVideoRequestOptionsVersion.current
                options.deliveryMode = PHVideoRequestOptionsDeliveryMode.automatic
                assets.append(asset)
            }
        }
        
        for asset in assets {
            print("8888888888888888888888888")
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (AVAsset, AVAudio, info) in
                let icon = self.playFileParser.iconWithAVAsset(avasset: AVAsset!)
                let avUrlAsset:AVURLAsset = AVAsset! as! AVURLAsset
                let path = avUrlAsset.url.path
                let playModel = PlayModel.init(name: "xxx", size: "xxx", time: "xxx", path: path, icon: icon)
                arr.append(playModel)
                print("77777777777777777777777")
            })
        }
               
    }

}
