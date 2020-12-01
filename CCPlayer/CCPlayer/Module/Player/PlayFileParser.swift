//
//  PlayFileParser.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/22.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import PhotosUI

class PlayFileParser: NSObject {
    
    func iconOfVideo(filePath:String) -> UIImage {
        let url = URL(fileURLWithPath: filePath)
        let asset = AVURLAsset.init(url: url, options: nil)
        let icon = iconWithAVAsset(avasset: asset)
        
        return icon
    }
    
    func iconWithAVAsset(avasset:AVAsset) -> UIImage {
        let gen = AVAssetImageGenerator.init(asset: avasset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(2.0, preferredTimescale: 1)
        var icon:UIImage = UIImage.init()
        var actualTime : CMTime = CMTimeMakeWithSeconds(0, preferredTimescale: 0)
            do {
                let image = try gen.copyCGImage(at: time, actualTime: &actualTime)
                icon = UIImage.init(cgImage: image)
            } catch  {
                print("错误")
            }
        return icon
    }
    
    func nameOfVideo(filePath:String) -> String {
        let url:URL = URL(fileURLWithPath: filePath)
        let name = url.lastPathComponent
        return name
    }
    
    func totalTimeOfVideo(filePath:String) -> String {
        let url = URL(fileURLWithPath: filePath)
        let playItem = AVPlayerItem(url: url as URL)
        let totalTime:Int = Int(CMTimeGetSeconds(playItem.asset.duration))
        
        let time = String(format: "%02d:%02d:%02d",(Int(totalTime) % 3600) / 60, Int(totalTime) / 3600,Int(totalTime) % 60)
        return time
    }
    
    func sizeOfVideo(filePath:String) -> String {
        var fileSize : UInt64 = 0
        var unit = "GB"
        var size:Float = 0.0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = attr[FileAttributeKey.size] as! UInt64
             
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
            
            if fileSize/(1000*1000*1000) >= 1 {
                unit = "GB"
                size = Float(Int(fileSize)/(1000*1000*Int(1000)))
            } else if fileSize/(1000*1000) >= 1 {
                unit = "MB"
                size = Float(Double(fileSize)/(1000*1000.0))
            } else {
                unit = "KB"
                size = Float(Double(fileSize)/1000)
            }
        } catch {
            print("Error: \(error)")
        }
        return String(format: "%.2f", size) + unit
    }
    
    func getAllPHAssetFromSysytem(completion: @escaping (Array<PlayModel>)->())  {
        var models = Array<PlayModel>()
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
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: { (AVAsset, AVAudio, info) in
                let icon = self.iconWithAVAsset(avasset: AVAsset!)
                let avUrlAsset:AVURLAsset = AVAsset! as! AVURLAsset
                let path = avUrlAsset.url.path
                let playModel = PlayModel.init(name: "xxx", size: "xxx", time: "xxx", path: path, icon: icon)
                models.append(playModel)
                if models.count == assets.count {
                    completion(models)
                }
            })
        }
    }
}
