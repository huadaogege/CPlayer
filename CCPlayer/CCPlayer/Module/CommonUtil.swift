//
//  CommonUtil.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/28.
//

import Foundation
import Photos

class CommonUtil: NSObject {
    
    func base64Encoding(plainString:String) -> String {
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    func base64Decoding(encodedString:String) -> String {
        let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
    func needGotoSettingToOpenAccessAlbum() -> Bool {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.denied ||
           PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.restricted {
            return true
        }
        return false
    }
    
    func photoAlbumIsAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
    }
    
    func requestPhotoAlbumAccess() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == PHAuthorizationStatus.authorized {
                    
                } else if status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.restricted {
                    
                }
            }
        }
    }
}


