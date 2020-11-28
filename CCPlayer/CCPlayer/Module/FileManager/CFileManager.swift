//
//  FileManager.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/25.
//

import Foundation

class CFileManager: NSObject {
    
    let manager = FileManager.default
    
    override init() {
        super.init()
        
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        print(url)
    }
    
    func searchDocumentsPaths() -> Array<Any> {
        var paths = Array<String>()
        let urlForDocument = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let url = urlForDocument[0] as URL
        let contentsOfPath:Array<String> = try! manager.contentsOfDirectory(atPath: url.path)

        for fileName in contentsOfPath {
            let path = url.path + "/" + fileName
            paths.append(path)
        }
        return paths
    }
    
    
    
    
}
