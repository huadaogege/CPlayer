//
//  FileManager.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/25.
//

import Foundation

class CFileManager: NSObject {
    
    let manager = FileManager.default
    let commonUtil = CommonUtil.init()
    
    override init() {
        super.init()
        
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        print(url)
    }
    
    func searchFilePaths(isPrivate:Bool) -> Array<Any> {
        var paths = Array<String>()
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        var path = url.path
        if isPrivate {
            path = path + "/privatePath"
            if !manager.fileExists(atPath: path) {
                try! manager.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            }
        }
        let contentsOfPath:Array<String> = try! manager.contentsOfDirectory(atPath: path)
        for fileName in contentsOfPath {
            if !isPrivate && fileName == "privatePath" {
                continue
            }
            let p = path + "/" + fileName
            paths.append(p)
        }
        return paths
    }
    
    func preparePlayModels(isPrivate:Bool) -> Array<PlayModel> {
        let pathItems = searchFilePaths(isPrivate: isPrivate)
        if pathItems.count == 0 {
            return Array.init()
        }
        
        var models = Array<PlayModel>()
        let parser = PlayFileParser()
        
        for index in 0...(pathItems.count - 1) {
            let filePath = pathItems[index] as! String
            let image = parser.iconOfVideo(filePath: filePath)
            let name = parser.nameOfVideo(filePath: filePath)
            let time = parser.totalTimeOfVideo(filePath: filePath)
            let size = parser.sizeOfVideo(filePath: filePath)
            let videFrameBounds = parser.videoFrameBounds(filePath: filePath)
            
            let playModel = PlayModel.init()
            playModel.name = name
            playModel.size = size
            playModel.time = time
            playModel.path = filePath
            playModel.icon = image
            playModel.bounds = videFrameBounds
            models.append(playModel)
        }
        return models
    }
    
    
    func privateSpacePaths() -> Array<Any> {
        var paths = Array<String>()
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let privateDirPath = url.path + "/privatePath"
        
        if !manager.fileExists(atPath: privateDirPath) {
            try! manager.createDirectory(at: URL(fileURLWithPath: privateDirPath), withIntermediateDirectories: true, attributes: nil)
        }
        let contentsOfPath:Array<String> = try! manager.contentsOfDirectory(atPath: privateDirPath)
        for fileName in contentsOfPath {
            let path = privateDirPath + "/" + fileName
            paths.append(path)
        }
        return paths
    }
    
    func moveToPrivatePath(path:String) {
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let privateDirPath = url.path + "/privatePath"
        
        if !manager.fileExists(atPath: privateDirPath) {
            try! manager.createDirectory(at: URL(fileURLWithPath: privateDirPath), withIntermediateDirectories: true, attributes: nil)
        }
        
        let originFileName = URL(fileURLWithPath: path).lastPathComponent
        let encodeFileName = originFileName
           // commonUtil.base64Encoding(plainString: originFileName)
        let privatePath = privateDirPath + "/" + encodeFileName
        
        try! manager.moveItem(at: URL(fileURLWithPath: path), to: URL(fileURLWithPath: privatePath))
    }
    
    func moveToPublicPath(path:String) {
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let publicPath = url.path
        
        let originFileName = URL(fileURLWithPath: path).lastPathComponent
        let decodeFileName = originFileName
           // commonUtil.base64Decoding(encodedString: originFileName)
        let publicFilePath = publicPath + "/" + decodeFileName
        
        try! manager.moveItem(at: URL(fileURLWithPath: path), to: URL(fileURLWithPath: publicFilePath))
    }
}
